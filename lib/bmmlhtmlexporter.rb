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
				text.gsub!(/\[/,'<a href="#">')
				text.gsub!(/\]/,'</a>')
				text.gsub!(/\t/,'&nbsp;&nbsp;&nbsp;&nbsp;')
			end unless text.nil? and text.empty?
			text
		end


		#TODO: implement this
		def render_accordion
		end

		#TODO: implement this
		def render_alert
		end

		#TODO: implement this
		def render_arrow
		end

		#TODO: implement this
		def render_barchart
		end

		def render_breadcrumbs(text,style)
			text.split(',').join(' > ')
		end


		#TODO: implement this
		def render_browserwindow(text,style)
			text
		end

		def render_button(text,style)
			s = HtmlStyle.new
			s["width"] = style["width"]
			text = "no text found" if text.nil?
			'<button type="button" style="'+style.to_s+'">'+text+'</button>'
		end

		def render_buttonbar(text,style)
			text
		end

		#TODO: implement this
		def render_calendar
		end

		#TODO: implement this
		def render_callout
		end

		#TODO: implement this
		def render_canvas(text,style)
			text
		end

		def render_checkbox(text,style)
			text+" <INPUT TYPE=CHECKBOX NAME=\""+text+"\">"
		end


		#TODO: implement this
		def render_colorpicker
		end

		#TODO: implement this
		def render_columnchart(text, style)
			text
		end

		def render_combobox(text,style)
			render = "<select name=\"combobox\">"
			text.split('/').each do |t|
				render << "<option value=\""+t+"\">"+t+"</option>"
			end
			render << "</select></div>"
			render
		end

		#TODO: implement this
		def render_coverflow
		end

		#TODO: implement this
		def render_datagrid(text,style)
			text
		end

		#TODO: implement this
		def render_datechooser
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


		def render_formattingtoolbar(text,style)
			"<img src=\"images/formattingtoolbar.png\" />"
		end


		#TODO: implement this
		def render_hcurly
		end

		#TODO: implement this
		def render_helpbutton
		end

		#TODO: implement this
		def render_horizontalscrollbar
		end

		def render_hrule(text,style)
			"<h />"
		end

		#TODO: implement this
		def render_hslider
		end

		#TODO: implement this
		def render_hsplitter(text,style)
			"<div style=\"background-color: grey; width:"+style["width"]+";\" name=\"vsplitter+\">&nbsp;</div>"
		end

		#TODO: implement this
		def render_icon(text,style)
			text
		end

		#TODO: implement this
		def render_iconlabel
		end

		#TODO: implement this
		def render_image
		end

		#TODO: implement this
		def render_iphone
		end

		#TODO: implement this
		def render_iphonekeyboard
		end

		#TODO: implement this
		def render_iphonemenu
		end

		#TODO: implement this
		def render_iphonepicker
		end

		def render_label(text,style)
			'<label for="'+text+'">'+text+'</label>'
		end

		#TODO: implement this
		def render_linechart
		end

		#TODO: implement this
		def render_link
		end

		#TODO: implement this
		def render_linkbar(text, style)
			text
		end

		#TODO: implement this
		def render_list(text,style)
			output = "<ul>"
			text.each do |line|
				line.chomp!
				output << "<li>"+line+'</li>'
			end
			output << "</ul>"
			output
		end

		#TODO: implement this
		def render_map
		end

		#TODO: implement this
		def render_mediacontrols
		end

		#TODO: implement this
		def render_menu
		end

		#TODO: implement this
		def render_menubar
		end

		#TODO: implement this
		def render_modalscreen
		end

		#TODO: implement this
		def render_multilinebutton
		end

		#TODO: implement this
		def render_numericstepper(text,style)
			'<p><span class="numeric-stepper"> 
			<input type="text" name="ns_textbox" size="2" /> 
			<button type="submit" name="ns_button_1" value="1" class="plus">+</button> 
			<button type="submit" name="ns_button_2" value="-1" class="minus">-</button> 
			</span></p>'
		end

		#TODO: implement this
		def render_paragraph(text,style)
			output = ""
			text.each do |line|
				line.chomp!
				output << line+'<br />'
			end
			"<p>"+output+"</p>"
		end

		#TODO: implement this
		def render_piechart(text,style)
			text
		end

		#TODO: implement this
		def render_pointybutton(text,style)
			"<input type=\"submit\" value=\""+text+"\">"
		end

		#TODO: implement this
		def render_progressbar
		end

		#TODO: implement this
		def render_radiobutton
		end

		#TODO: implement this
		def render_redx
		end

		#TODO: implement this
		def render_roundbutton
		end

		#TODO: implement this
		def render_scratchout
		end

		#TODO: implement this
		def render_searchbox
		end

		def render_stickynote(text,style)
			"<div style=\"width: 100%; height: 100%;background-color: yellow;\"><b>Sticky note</b><br />"+text+"</div>"
		end


		#TODO: implement this
		def render_switch
		end

		#TODO: implement this
		def render_tabbar(text, style)
			text
		end

		#TODO: implement this
		def render_tagcloud
		end

		def render_textarea(text,style)
			"<textarea>"+text+"</textarea>"
		end


		def render_textinput(text,style)
			myStyle = HtmlStyle.new
			myStyle["width"] = style["width"]
			'<input type="text" value="'+text+'" size='+(myStyle["width"].to_i/9).to_s+'>'
		end


		#TODO: implement this
		def render_title(text,style)
			"<h1>"+text+"</h1>"
		end

		def render_titlewindow(text,style)
			text
		end


		#TODO: implement this
		def render_tooltip
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

		#TODO: implement this
		def render_verticaltabbar
		end

		#TODO: implement this
		def render_verticalscrollbar
		end

		#TODO: implement this
		def render_videoplayer
		end

		#TODO: implement this
		def render_vcurly
		end

		#TODO: implement this
		def render_vsplitter(text,style)
			"<div style=\"background-color: grey; height:"+style["height"]+";\" name=\"vsplitter+\">&nbsp;</div>"
		end

		#TODO: implement this
		def render_volumeslider
		end

		#TODO: implement this
		def render_vrule
		end

		#TODO: implement this
		def render_vslider
		end

		#TODO: implement this
		def render_webcam
		end


		def get_head
			'<style type="text/css">
			body { font-size: 0.8em; }
			.numeric-stepper {
				width:3.425em;
				height:1.6em;
				display:block;
				position:relative;
				overflow:hidden;
				border:1px solid #555;
			}

			.numeric-stepper input {
				width:75%;
						height:100%;
						float:left;
						text-align:center;
						vertical-align:center;
						font-size:125%;
											border:none;
											background:none;
			}

			.numeric-stepper button {
				width:25%;
						height:50%;
						font-size:0.5em;
						padding:0;
						margin:0;
						z-index:100;
						text-align:center;
						position:absolute;
						right:0;
			}
			.numeric-stepper button.minus {
				bottom:0;
			}
			</style>'
		end
		def build_style(l, t, w, h, z)
			HtmlStyle.new.tap { |style|
				style["left"] = l
				style["top"] = t
				style["width"] = w
				style["height"] = h
				style["zindex"] = z
			}
		end

		def export
			@output_content = "<html>"
			@output_content << "<head>" << get_head << "</head>"
			@output_content << "<body>"
			i = 1
			ele = 0
			@doc.root.each_element('//control') { |control|
				type,left,top,width,height,zindex,text = BmmlHelpers.decode_control(control)
				style = build_style(left,top,width,height,zindex)
				text = format(text).url_decode
				p i.to_s+": "+type

				# if we encounter a group
				if type.empty? or type.nil?
					p "prout"
					next
				end
				p "prouta"+type

				@output_content << "<div style=\"vertical-align: middle; border: 0px black solid; background-color:"+"; position:absolute; z-index:"+zindex+';'+
					"left:"+left+"px;"+
					"top:"+top+"px;"+
					"width:"+width+"px;"+
					"height:"+height+"px;"+
					"\">"+render(type,format(text),style)+"</div><br />\n" unless width.nil? or height.nil?
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
