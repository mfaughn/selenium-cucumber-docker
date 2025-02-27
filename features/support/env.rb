require 'rspec' #for page.shoud etc
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'selenium-webdriver'
require 'webdrivers'
require 'pry'
require 'rainbow'

in_container = %x(echo `[ ! -f /.dockerenv ]` $?).to_i == 1
selenium_server = in_container ? 'selenium1' : '0.0.0.0'
remote_url = URI::Generic.new('http', nil, selenium_server, 4444, nil, '/wd/hub', nil, nil, nil)

Capybara.register_driver :remote_chrome do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 180
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--allow-insecure-localhost')
  options.add_argument('--ignore-certificate-errors')
  options.add_option('aws:maxDurationSecs', 2400)
  Capybara::Selenium::Driver.new(app, browser: :remote, http_client: client, url: remote_url, options: options)
end

=begin
Capybara.register_driver :remote_chrome do |app|
  
  
  
  
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--allow-insecure-localhost')
  options.add_argument('--ignore-certificate-errors')
  
  
  
  
  
  Capybara::Selenium::Driver.new(app,
  :browser => :remote,
  :capabilities => :chrome,
  :capabilities => options,
  :url => "#{selenium_hostname}:4444/wd/hub")
end
=end

Capybara::Screenshot.register_driver(:remote_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.configure do |config|
  config.run_server     = false
  config.default_driver = :remote_chrome
  config.app_host       = 'http://www.google.com' # change this to point to your application
end

# Capybara::Screenshot.prune_strategy = :keep_last_run
