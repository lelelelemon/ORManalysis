
Representation rules:
1. Indent to indicate the calling relationships.
A: xxxx
		B: xxxx
indicates B is called within A
2. Source url is usually included.



File format: 
1. *.txt file, which * is the name of the view folder.
	Generally html.erb files under the view folder indicates webpage actions.
2. Format: 
		attributes: value
	Attributes include ->
		>> url: the url used by the application (web user)
		>> action: webpage (html) action, including GET, POST, etc.
		>> controller_function: controller function gets as the result of the webpage action. In the format of controller_name.function_name
		>> controller_function_source: the github url source of the function definition
		>> model_function: similar to controller_function
		>> model_function_source
		>> DB_query: the MySQL query trigger by calling the model function
		>> DB_table
		>> DB_field
		>> DB_operation
3. You're welcomed to add in more attributes! I wish to organize the information in a well-formatted way so that we may analyze the statistics by writing some parsing scripts.
