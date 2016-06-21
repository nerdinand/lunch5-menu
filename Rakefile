def ask?(question)
  print question
  response = STDIN.gets.chomp.downcase
  %w(yes y yep true ja).include?(response)
end

def docker_container_version
  `cat docker-container-version`.strip
end

def docker_repository_host
  `cat docker-repository-host`.strip
end

namespace :docker do
  task :ask_version_ok do
    unless ask?("Did you remember to change the version in the docker-version file (currently #{docker_container_version})? ")
      exit 1
    end
  end

  desc 'Build docker container'
  task :build do
    system "docker build -t #{docker_container_version} --rm ."
  end

  desc 'Tag docker container'
  task :tag do
    system "docker tag #{docker_container_version} #{docker_repository_host}/#{docker_container_version}"
  end

  desc 'Push docker container'
  task :push do
    system "docker push #{docker_repository_host}/#{docker_container_version}"
  end

  task :git_tag do
    version = docker_container_version.split(':').last
    system "git tag #{version}"
    system 'git push --tags'
  end

  desc 'Build, tag and push a docker container'
  task all: [:ask_version_ok, :build, :tag, :push, :git_tag] do
    puts 'Done.'
  end
end

