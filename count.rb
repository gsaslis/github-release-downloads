require 'net/http'
require 'json'


def countReleaseDownloads(release)
  releaseDownloadsTotal = 0
  releaseAssets = release['assets']
  unless releaseAssets.nil?
    releaseAssets.each do |asset|
      releaseDownloadsTotal += asset['download_count']
    end
    puts " ; #{release['name']} ; #{release['published_at']} ; #{releaseDownloadsTotal}"
  end
  releaseDownloadsTotal
end

def getReleasesForRepo(user, repo, token)
  releasesURI = URI("https://api.github.com/repos/#{user}/#{repo['name']}/releases")
  releasesHttp = Net::HTTP.new(releasesURI.host, releasesURI.port)
  releasesRequest = Net::HTTP::Get.new(releasesURI.request_uri)
  releasesRequest.add_field 'Authorization', "Token #{token}"
  releasesHttp.use_ssl = true
  releasesResponse = releasesHttp.request(releasesRequest)
  releases = JSON.parse(releasesResponse.body)
  releases
end

def getMaxUserRepositoriesAllowedByGithubAPI(user, authToken, current_page)
  url = "https://api.github.com/users/#{user}/repos?per_page=100&page=#{current_page}"
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  request.add_field 'Authorization', "Token #{authToken}"
  http.use_ssl = true
  response = http.request(request)
  repos = JSON.parse(response.body)
  repos
end

authToken = ENV['GITHUB_AUTH_TOKEN']
user = ENV['GITHUB_USERNAME']

pages = 2 # we have less than 200 repos
current_page = 1 # pages don't start at 0   : P
allUserRepos = []

userDownloadsTotal = 0

while current_page <= pages do
  repos = getMaxUserRepositoriesAllowedByGithubAPI(user, authToken, current_page)

  repos.each do |repo|
    
    projectDownloadsTotal = 0
    puts "#{repo['name']}"
    allUserRepos.push "#{repo['name']}"

    releases = getReleasesForRepo(user, repo, authToken)

    releases.each do |release|
      projectDownloadsTotal += countReleaseDownloads(release)
    end

    puts "Total Downloads ; ; ; #{projectDownloadsTotal} \n\n"
    userDownloadsTotal += projectDownloadsTotal
  end

  current_page=current_page+1

end

puts "User Total Downloads ; ; ; #{userDownloadsTotal}"
