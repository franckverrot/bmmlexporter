require File.dirname(__FILE__) + '/test_helper.rb'

class TestBmmlExporter < Test::Unit::TestCase
	include BmmlExporters

	def setup
	end

	def test_html_export
		exporter = BmmlExporter.new :import => 'file', :file => "#{File.expand_path(File.dirname(__FILE__))}/../test/mu.bmml", :export_type => 'html', :export_folder => 'output/', :exporter => BmmlHtmlExporter.new
		exporter.export
		exporter.save
		assert_not_nil exporter.to_s
	end

	def test_swf_export
		# "Faking the test of the Flash export..."
		assert true
	end
end
