package com.zewei;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;


import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Node;
import org.jsoup.select.Elements;
import org.jsoup.select.NodeVisitor;

public class ReadErbFile {
	
	static String readFile(String path, Charset encoding) throws IOException{
		byte[] encoded = Files.readAllBytes(Paths.get(path));
		return new String(encoded, encoding);
	}
	
	public static void main(String[] args){
		try {
			
			String fileName = "C:\\Users\\jasonchuzewei\\Desktop\\DB_Performance_Proj\\play\\views\\extract_href_form\\_comment.html.erb";
			//String fileName = "C:\\Users\\jasonchuzewei\\Desktop\\DB_Performance_Proj\\play\\lobsters\\app\\views\\comments\\_commentbox.html.erb";
			
			String content = "<html>" + readFile(fileName, StandardCharsets.UTF_8) + "</html>";
			
			
			//String content_modified = content.replaceAll("<%=.*%>", "___").replaceAll("<%.*%>", "+++")s;
			Document doc = Jsoup.parse(content);
			
			Elements elements = doc.getAllElements();
			
			HrefVisitor hrefVisitor = new HrefVisitor();
			elements.traverse(hrefVisitor);
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
}
class HrefVisitor implements NodeVisitor{

	@Override
	public void head(Node n, int depth) {
		if (n.hasAttr("href")){
			System.out.println("href tag: " + n);
			System.out.println("url: " + n.attr("href"));
		}
		
	}

	@Override
	public void tail(Node n, int depth) {
		
	}
	
}
