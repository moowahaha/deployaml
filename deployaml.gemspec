# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{deployaml}
  s.version = "0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Hardisty"]
  s.date = %q{2010-09-05}
  s.default_executable = %q{deployaml}
  s.description = %q{FIX (describe your package)}
  s.email = ["moowahaha@hotmail.com"]
  s.executables = ["deployaml"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "fixtures/local_deployment_test_project/harold.txt", "fixtures/local_git_deployment_test_project/benjamin.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "bin/deployaml", "blah.rb", "bob", "cmd.rb", "deplo.yml", "deployaml.gemspec", "fixtures/local_deployment_test_project/deplo.yml", "fixtures/local_deployment_test_project/harold.txt", "fixtures/local_git_deployment_test_project/benjamin.txt", "fixtures/local_git_deployment_test_project/deplo.yml", "fixtures/local_git_deployment_test_repo/HEAD", "fixtures/local_git_deployment_test_repo/config", "fixtures/local_git_deployment_test_repo/description", "fixtures/local_git_deployment_test_repo/hooks/applypatch-msg.sample", "fixtures/local_git_deployment_test_repo/hooks/commit-msg.sample", "fixtures/local_git_deployment_test_repo/hooks/post-commit.sample", "fixtures/local_git_deployment_test_repo/hooks/post-receive.sample", "fixtures/local_git_deployment_test_repo/hooks/post-update.sample", "fixtures/local_git_deployment_test_repo/hooks/pre-applypatch.sample", "fixtures/local_git_deployment_test_repo/hooks/pre-commit.sample", "fixtures/local_git_deployment_test_repo/hooks/pre-rebase.sample", "fixtures/local_git_deployment_test_repo/hooks/prepare-commit-msg.sample", "fixtures/local_git_deployment_test_repo/hooks/update.sample", "fixtures/local_git_deployment_test_repo/info/exclude", "fixtures/local_git_deployment_test_repo/objects/0b/7ea3a1042fc0c0c076ccd19226ef5d966ece1f", "fixtures/local_git_deployment_test_repo/objects/91/1efce114a6786441ee430bc565fde01719caa5", "fixtures/local_git_deployment_test_repo/objects/a5/529ea8bd335679242e6ca6d5c270f89396cd68", "fixtures/local_git_deployment_test_repo/objects/b8/6cc153c4ba3d88fb70736e17d3594bd29187cf", "fixtures/local_git_deployment_test_repo/refs/heads/master", "lib/deployaml.rb", "lib/deployaml/deployment.rb", "lib/deployaml/destination.rb", "lib/deployaml/local_destination.rb", "lib/deployaml/pre_install/minify.rb", "lib/deployaml/pre_install/write_string_to_file.rb", "lib/deployaml/remote_destination.rb", "lib/deployaml/scm/filesystem.rb", "lib/deployaml/scm/git.rb", "lib/deployaml/scm_base.rb", "reports/rspec/specs.html", "spec/deployaml_spec.rb", "spec/deployment_spec.rb", "spec/destinations/destination_spec.rb", "spec/destinations/local_destination_spec.rb", "spec/destinations/remote_destination_spec.rb", "spec/integration/local_deployment_spec.rb", "spec/integration/local_git_repo_deployment_spec.rb", "spec/integration/remote_git_repo_to_remote_host_spec.rb", "spec/scm/filesystem_spec.rb", "spec/scm/git_spec.rb", "spec/scm/scm_shared_spec.rb", "spec/tasks/minify_spec.rb", "spec/tasks/write_string_to_file_spec.rb", "ssh.rb", "stuff_not_to_be_committed/host_and_username_and_password.yml", "stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml", "tasks/test.rake", "vendor/yuicompressor/build.xml", "vendor/yuicompressor/build/yuicompressor-2.4.2.jar"]
  s.homepage = %q{http://github.com/moowahaha/deployaml}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{deployaml}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{FIX (describe your package)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<net-ssh>, [">= 2.0.11"])
      s.add_runtime_dependency(%q<net-scp>, [">= 1.0.3"])
      s.add_runtime_dependency(%q<highline>, [">= 1.2.9"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.1"])
    else
      s.add_dependency(%q<net-ssh>, [">= 2.0.11"])
      s.add_dependency(%q<net-scp>, [">= 1.0.3"])
      s.add_dependency(%q<highline>, [">= 1.2.9"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<hoe>, [">= 2.6.1"])
    end
  else
    s.add_dependency(%q<net-ssh>, [">= 2.0.11"])
    s.add_dependency(%q<net-scp>, [">= 1.0.3"])
    s.add_dependency(%q<highline>, [">= 1.2.9"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<hoe>, [">= 2.6.1"])
  end
end
