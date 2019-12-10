# coding: utf-8
class Create < Thor::Group
  include Thor::Actions

  # Define arguments and options
  argument :name
  argument :repo_name
  argument :project

  def self.source_root
    File.dirname(__FILE__)
  end

  def boilerplate
    @boilerplate ||= File.read(template("files/BOILERPLATE.txt.tt", "#{repo_name}/BOILERPLATE.txt")).chomp
  end

  def create_root
    [
      'README.md',
      'CONTRIBUTING.md',
      'Gemfile',
    ].each do |f|
      template("files/#{f}.tt", "#{repo_name}/#{f}")
    end
    [
      'CODE_OF_CONDUCT.md',
      'LICENSE.txt',
    ].each do |f|
      copy_file("files/#{f}", "#{repo_name}/#{f}")
    end
    copy_file("files/gitignore", "#{repo_name}/.gitignore")
  end

  def create_lib
    [
      'cli',
      'command',
      'commands',
      'config',
      'errors',
      'version',
      'commands/hello',
    ].each do |f|
      template("files/lib/cmd/#{f}.rb.tt", "#{repo_name}/lib/#{name}/#{f}.rb")
    end
  end

  def create_bin
    template("files/bin/cmd.tt", "#{repo_name}/bin/#{name}")
    chmod("#{repo_name}/bin/#{name}", 0755)
  end

  def run_bundler
    inside repo_name do
      Bundler.with_clean_env do
        run('bundle install --path=vendor')
        run('git init')
        run('git commit --allow-empty -m "Initial empty commit"')
      end
    end
  end

  def clean_boilerplate
    remove_file("#{repo_name}/BOILERPLATE.txt")
  end
end
