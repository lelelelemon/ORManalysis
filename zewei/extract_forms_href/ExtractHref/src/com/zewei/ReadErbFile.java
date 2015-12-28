package com.zewei;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;


import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class ReadErbFile {
	
	public static String source_folder_name = "projects";
	public static String urls_folder_name = "urls";
	public static PrintWriter writer;
	
	static String readFile(String path, Charset encoding) throws IOException{
		byte[] encoded = Files.readAllBytes(Paths.get(path));
		return new String(encoded, encoding);
	}
	
	public static void main(String[] args){
		
		try {
			Files.walk(Paths.get(source_folder_name)).forEach(filePath -> {
			    if (Files.isRegularFile(filePath) && filePath.toString().endsWith("html.erb")) {
			    	System.out.println(filePath);
			    	extractURLFromFile(filePath);
			    }
			});
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
	}

	
	public static void extractURLFromFile(Path filePath){
		try {
			
			String content = "<html>" + readFile(filePath.toString(), StandardCharsets.UTF_8) + "</html>";
			//String content_modified = content.replaceAll("<%=.*%>", "___").replaceAll("<%.*%>", "+++")s;
			Document doc = Jsoup.parse(content);
			

			
			//Elements elements = doc.getAllElements();

			String write_to_file = filePath.toString().replace(source_folder_name, urls_folder_name);
			String write_to_folder = write_to_file.substring(0, write_to_file.lastIndexOf('\\'));
			
			
			//create directories recursively
			if (!((new File(write_to_folder)).mkdirs())){
				System.out.println("failed creating " + write_to_folder);
			}

			writer = new PrintWriter(write_to_file, "UTF-8");
			writer.write("route = Rails.application.routes\n");
			
			Elements links = doc.select("a[href]"); // Select next links - add more restriction!

	        for( Element link : links ) // Iterate over all Links
	        {
	        	System.out.println(link);
//				System.out.println("href tag: " + n);
//				System.out.println("url: " + n.attr("href"));
				
				String url = link.attr("href");
				url = url.replaceAll("<%=.*%>", "2");
//				url = url.replace("%>", "");
//				url = url.replace(" ", "");
				writer.write("route.recognize_path \"" + url + "\"\n");
	        }
			
//			
//			HrefVisitor hrefVisitor = new HrefVisitor();
			//elements.traverse(hrefVisitor);
			writer.close();
		}catch(Exception e){
			e.printStackTrace();
		}

	}

}

