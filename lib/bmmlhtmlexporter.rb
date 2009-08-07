#require 'bmmlexporter'
#require File.dirname(__FILE__) + '/../lib/bmmlexporter'

class String
	def url_decode
		CGI::unescape(self)
	end
end

module BmmlExporters

	class BmmlHtmlExporter
		def to_s
			@output_content
		end

		def initialize(*opts)
			super
			@output_content = ""
		end

		class HtmlStyle < Hash
			def to_s
				s = ""
				each { |key,value|
					s << key+": "+value+";"
				}
				s
			end
		end

		def set_options(*opts)
			options = *opts
			# :import (file,inline), :file(name.bmml), :export_type (html/flex), :export_folder('./output')

			@output = "output.html" #options[:export_folder]+'/index.html'
			@doc = Document.new(File.new(options[:file]))
		end

		def render(type,text,*args)
			send('render_'+type.to_s,text,*args)
		end

		def make_color
			r = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']
			#"#"+r[rand(1+15)] +  r[rand(1+15)] +  r[rand(1+15)] +  r[rand(1+15)] +  r[rand(1+15)] +  r[rand(1+15)] 
			r = ['blue','yellow','red','green','purple','pink','cyan']
			r[rand(r.size-1)+1]
		end

		def format(text)
			transformations = {
				"/_*_/" => "<b>\1</b>"
			}
			transformations.each do |what, how|
				#text.gsub!(what,how)
				text.gsub!(/_([^_]+)_/,'<b>\1</b>')
			end
			text
		end

		def render_button(text,style)
			s = HtmlStyle.new
			s["width"] = style["width"]
			text = "no text found" if text.nil?
			'<button type="button" style="'+style.to_s+'">'+text+'</button>'
		end

		def render_titlewindow(text,style)
			text
		end

		def render_tree(text,style)
			html = ""
			groups = text.split('F')
			groups.shift

			groups.each do |group|
				lines = group.split('%0A')
				html << "<ul>"+lines.shift
				lines.each do |line|
					html << "<li>"+line+"</li>"
				end
				html << "</ul>"
			end
			html
		end

		def render_label(text,style)
			'<label for="'+text+'">'+text+'</label>'
		end

		def render_breadcrumbs(text,style)
			text.split(',').join(' > ')
		end

		def render_buttonbar(text,style)
			text
		end

		def render_textinput(text,style)
			myStyle = HtmlStyle.new
			myStyle["width"] = style["width"]
			'<input type="text" value="'+text+'" size='+(myStyle["width"].to_i/9).to_s+'>'
		end

		def render_combobox(text,style)
			render = "<select name=\"combobox\">"
			text.split('/').each do |t|
				render << "<option value=\""+t+"\">"+t+"</option>"
			end
			render << "</select></div>"
			render
		end

		def render_canvas(text,style)
			text
		end

		def render_hrule(text,style)
			"<h />"
		end
		$fieldset_was_already_opened = false
		def render_fieldset(text,style)
			myStyle = HtmlStyle.new
			myStyle["width"] = style["width"].to_i - 20
			myStyle["height"] = style["height"].to_i - 20
			response = ""
			response << "</fieldset>" if $fieldset_was_already_opened
			response << "<fieldset style=\"height: " + myStyle["height"].to_s + "; width: " + myStyle["width"].to_s + "\"><legend>" + text + "</legend>"
			$fieldset_was_already_opened = true
			response
		end

		def render_textarea(text,style)
			"<textarea>"+text+"</textarea>"
		end

		def render_formattingtoolbar(text,style)
			"<img src=\"images/formattingtoolbar.png\" />"
		end

		def render_checkbox(text,style)
			text+" <INPUT TYPE=CHECKBOX NAME=\""+text+"\">"
		end

		def render_stickynote(text,style)
			"<div style=\"width: 100%; height: 100%;background-color: yellow;\"><b>Sticky note</b><br />"+text+"</div>"
		end

		def export
			@output_content = "<html><body>"
			i = 1
			@doc.root.each_element('//control') { |control|
				color = make_color
				type = control.attributes["controlTypeID"].gsub!(/com.balsamiq.mockups::/,'').to_s.downcase
				text = ""
				left = control.attributes["x"]
				top = control.attributes["y"]
				width = control.attributes["w"]
				if width.to_i == -1 and width.to_i < control.attributes["measuredW"].to_i
					width = control.attributes["measuredW"] 
				end
				height = control.attributes["h"] 
				if height.to_i == -1 and height.to_i < control.attributes["measuredH"].to_i
					height = control.attributes["measuredH"] 
				end
				zindex = control.attributes["zOrder"]

				style = HtmlStyle.new
				style["left"] = left
				style["top"] = top
				style["width"] = width
				style["height"] = height

				#	begin
				unless control[1].nil? or control[1][1].nil? or control[1][1].text.nil?
					text = control[1][1].text.url_decode
				end
				@output_content << "<div style=\"border: 0px black solid; background-color:"+"; position:absolute; z-index:"+zindex+';'+
					"left:"+left+"px;"+
					"top:"+top+"px;"+
					"width:"+width+"px;"+
					"height:"+height+"px;"+
					"\">"+render(type,format(text),style)+"</div><br />\n" unless width.nil? or height.nil?
				#	rescue Exception => e
				#		p "Control removed: "+control.to_s+" because "+e.message
				#	end
				i += 1
			}

			@output_content += "</body></html>"
		end

		def save
			File.open(@output, 'w') {|f| f.write(@output_content) }
		end

		def export!
			export
			save
		end
	end
end
