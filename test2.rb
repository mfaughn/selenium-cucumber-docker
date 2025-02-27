require 'rainbow'
require 'capybara'
require 'selenium-webdriver'
require 'rainbow'
in_container = %x(echo `[ ! -f /.dockerenv ]` $?).to_i == 1
selenium_server = in_container ? 'selenium1' : '0.0.0.0'
remote_url = URI::Generic.new('http', nil, selenium_server, 4444, nil, '/wd/hub', nil, nil, nil)

# Done for demo purposes here!
Capybara.server = :puma, { Silent: true }

Capybara.register_driver :remote_chrome do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  # client.read_timeout = 180
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--allow-insecure-localhost')
  options.add_argument('--ignore-certificate-errors')
  Capybara::Selenium::Driver.new(app, browser: :remote, http_client: client, url: remote_url, options: options)
end
=begin
Capybara.register_driver :remote_chrome do |app|
  Capybara::Selenium::Driver.new(app, {
    :browser              => :remote,
    # :url                  => "#{selenium_hostname}:4444/wd/hub",
    :url                  => "http://#{docker_ip}:4444/wd/hub",
    :desired_capabilities => Selenium::WebDriver::Remote::Capabilities.chrome("goog:chromeOptions" => {
      # Set launch flags similar to puppeteer's for best performance
      "args" => [
        "--disable-background-timer-throttling",
        "--disable-backgrounding-occluded-windows",
        "--disable-breakpad",
        "--disable-component-extensions-with-background-pages",
        "--disable-dev-shm-usage",
        "--disable-extensions",
        "--disable-features=TranslateUI,BlinkGenPropertyTrees",
        "--disable-ipc-flooding-protection",
        "--disable-renderer-backgrounding",
        "--enable-features=NetworkService,NetworkServiceInProcess",
        "--force-color-profile=srgb",
        "--hide-scrollbars",
        "--metrics-recording-only",
        "--mute-audio",
        "--headless",
        "--no-sandbox"
      ]
    }),
  })
end
=end

Capybara.default_driver = :remote_chrome

browser = Capybara.current_session
browser.visit 'https://example.com/'
puts browser.html
browser.driver.quit
