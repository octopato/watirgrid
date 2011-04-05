require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Using the Grid in GRIDinit style' do
  before(:all) do
    @controller = Controller.new(
      :drb_server_port  => 12357,
      :ring_server_port => 12358,
      :ring_server_host => '127.0.0.1',
      :loglevel => Logger::ERROR)
    @controller.start
    1.upto(5) do
      provider = Provider.new(
        :ring_server_port => 12358,
        :ring_server_host => '127.0.0.1',
        :drb_server_host => '127.0.0.1',
        :loglevel => Logger::ERROR,
        :browser_type => 'webdriver')
      provider.start
    end
  end

  after(:all) do
    @controller.stop
  end


  it 'should take 1 provider via a direct controller_uri' do
    grid = Watir::Grid.new(:controller_uri => 'druby://127.0.0.1:12357',
                           :drb_server_host => '127.0.0.1')
    grid.start(:quantity => 3, :take_all => true, :browser_type => 'webdriver')
    grid.size.should == 3
  end

  it 'should control the grid using an iterate helper method' do
    Watir::Grid.iterate(2, {
      :controller_uri => 'druby://127.0.0.1:12357',
      :loglevel => Logger::DEBUG}) do |browser, iteration, id|
          browser.goto "http://127.0.0.1/#iteration=#{iteration}&id=#{id}"
          sleep 5
      #browser = Watir::Browser.start("about:blank")
      end
  end

  it 'should take all remaining providers via a direct controller_uri' do
    grid = Watir::Grid.new(:controller_uri => 'druby://127.0.0.1:12357',
                           :drb_server_host => '127.0.0.1')
    grid.start(:take_all => true, :browser_type => 'webdriver')
    grid.size.should == 2
  end

end
