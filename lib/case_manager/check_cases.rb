# frozen_string_literal: true

# CaseManager#check_cases!
class CaseManager
  private

  def check_cases!
    app = Application.instance

    # Load configurations from config file
    configdata = ConfigFileReader.read(app.config_path)
    app.global = configdata[:global] || {}
    app.global[:tt_testname] = app.global[:tt_testname] || app.test_name
    app.global[:tt_sequence] = false if app.global[:tt_sequence].nil?

    # Create out dir
    outdir = app.global[:tt_outdir] ||
             File.join('var', app.global[:tt_testname])
    ensure_dir outdir
    @report.output_dir = outdir

    # Fill report head
    open_main_report(app.config_path)

    # create cases and run
    configdata[:cases].each { |config| @cases << Case.new(config) }
    start_time = run_all_cases # run cases

    uniques = collect_uniques_for_all_cases
    close_reports_for_all_cases(uniques)
    close_main_report(start_time)
  end

  def run_all_cases
    start_time = Time.now
    if Application.instance.global[:tt_sequence]
      verboseln "[INFO] Running in sequence (#{start_time})"
      # Run every case in sequence
      @cases.each(&:play)
    else
      verboseln "[INFO] Running in parallel (#{start_time})"
      threads = []
      # Run all cases in parallel
      @cases.each { |c| threads << Thread.new { c.play } }
      threads.each(&:join)
    end
    start_time
  end

  def collect_uniques_for_all_cases
    uniques = {} # Collect "unique" values from all cases
    @cases.each do |c|
      c.uniques.each do |key|
        if uniques[key].nil?
          uniques[key] = [c.id]
        else
          uniques[key] << c.id
        end
      end
    end
    uniques
  end

  def close_reports_for_all_cases(uniques)
    threads = []
    @cases.each { |c| threads << Thread.new { c.close uniques } }
    threads.each(&:join)

    # Build Hall of Fame
    build_hall_of_fame
  end
end
