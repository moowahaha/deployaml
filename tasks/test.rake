require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

task :test => ['test:covered']

namespace :test do
  report_dir = "reports"
  directory report_dir

  spec_opts = ["--colour", "--format", "progress"]

  rcov_opts = ["--include", "spec", "--exclude", "spec/*,gems/*,db/*,features/*,gremlin/lib/*,nagios_reporter/lib", "--rails"]
  rcov_report_dir = report_dir + "/rcov"

  desc "Run all specs in spec directory with RCov (excluding plugin specs)"
  Spec::Rake::SpecTask.new(:all_with_reports => [report_dir]) do |t|
    t.spec_opts = spec_opts + ["--format", "html:#{report_dir}/rspec/specs.html"]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_dir = rcov_report_dir
    t.rcov_opts = rcov_opts
  end


  RCov::VerifyTask.new(:covered => :all_with_reports) do |t|
        t.threshold = 100.0
        t.require_exact_threshold = false
        t.index_html = "#{rcov_report_dir}/index.html"
  end
end