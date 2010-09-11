require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'deployment')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'post_install', 'pending_migrations')

describe Deployaml::PostInstall::PendingMigrations do
  it "should run pending migrations" do
    FileUtils.rm_r('/tmp/pending_migrations_test') if File.exists?('/tmp/pending_migrations_test')
    FileUtils.mkdir_p('/tmp/pending_migrations_test/current')

    deployment = Deployaml::Deployment.new(
            'name' => 'tim',
            'repository' => {'path' => '/tmp/pending_migrations_test_repo'},
            'destinations' => [{'path' => '/tmp/pending_migrations_test'}],
            'post_install' => [
                    {
                            'task' => 'pending_migrations'
                    }
            ]
    )

    destination = Deployaml::Destination.new('path' => '/tmp/pending_migrations_test')

    File.open('/tmp/pending_migrations_test/current/Rakefile', 'w') do |fh|
      fh.print <<-eof
namespace :db do
    task :migrate do
        sh 'touch ran'
    end
end
      eof
    end

    Deployaml::PostInstall::PendingMigrations.new.run(deployment, destination, {})

    File.should exist("/tmp/pending_migrations_test/current/ran")
  end
end
