#$:.unshift(File.dirname(__FILE__)) unless
#  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'rexml/document'
require 'cgi'
require File.dirname(__FILE__) + '/bmmlhtmlexporter'
include REXML

module BmmlExporters
	VERSION = '0.0.1'

	class BmmlExporter
		attr_accessor :opts
		def initialize(*opts)
			set_options(*opts)
		end

		def to_s
			check_response_and_call(@exporter, :to_s)
		end

		def set_options(*opts)
			options = *opts

			raise "Require :import parameter" if options[:import].to_s.nil?
			raise "Require :export_type parameter" if options[:export_type].to_s.nil?

			if options[:import].eql? "file"
				raise "Require :file if :import => 'file'" if options[:file].nil?
			end

			raise "Require a valid :export_type: html / flex, mentioned " + options[:export_type] unless options[:export_type].eql? 'html' or options[:export_type].eql? 'flex'

			# Reminder: :import (file,inline), :file(name.bmml), :export_type (html/flex), :export_folder('./output')
			@exporter = options[:exporter]
			check_response_and_call(@exporter, :set_options, options)
		end

		def export
			check_response_and_call(@exporter, :export)
		end

		def save
			check_response_and_call(@exporter, :save)
		end

		def export!
			export
			save
		end

		def check_response_and_call(obj, method_symbol, *args)
			raise 'The exporter '+obj.class.to_s+' does not respond to the method '+method_symbol.to_s unless obj and obj.respond_to?(method_symbol)
			obj.send(method_symbol, *args)
		end
	end
end
