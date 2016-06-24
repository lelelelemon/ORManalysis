import sys

log_file = sys.argv[1]

number_of_rendered_views = 0
controller_action_count = 0
total_view_render_time = 0.0
total_duration_time = 0.0
total_number_of_rendered_views = 0

def process(line):
    global number_of_rendered_views # = 0
    global controller_action_count
    global total_view_render_time
    global total_duration_time
    global total_number_of_rendered_views
    total_duration = 0
    render_partial_time = 0
    render_template_time = 0
    if all(x in line for x in ["total_duration", "db_time", "view_runtime", "query_time", "query_in_view", "render_partial_time", "render_template_time"]):
        if not controller_action_count == 0:
            print "number_of_rendered_views: " + str(number_of_rendered_views) 
        print "\n" + line.strip()
        controller_action_count += 1
        number_of_rendered_views = 0
        items = line.split()
        for item in items:
            if "total_duration" in item:
#                print item
                total_duration = float(item.replace("total_duration=", ""))
                total_duration_time += total_duration
            elif "render_partial_time" in item:
#               print item
                render_partial_time = float(item.replace("render_partial_time=", ""))
                total_view_render_time += render_partial_time
                total_number_of_rendered_views += 1
            elif "render_template_time" in item:
#                print item
                render_template_time = float(item.replace("render_template_time=", ""))
                total_view_render_time += render_template_time
                total_number_of_rendered_views += 1
        print "render_partial_time percentage: " + str(render_partial_time / total_duration)
        print "render_template_time percentage: " + str(render_template_time / total_duration)
    elif "render_template" in line:
#        print line
        number_of_rendered_views += 1
    elif "render_partial" in line:
#        print line
        number_of_rendered_views += 1

with open(log_file) as f:
    for line in f:
        process(line)

print "total_duration_time: " + str(total_duration_time)
print "total_view_render_time: " + str(total_view_render_time)
print "percentage: " + str(total_view_render_time / total_duration_time)
print "total number of controller actions: " + str(controller_action_count)
print "total number of views rendered: " + str(total_number_of_rendered_views)
print "average number of views rendered per controller action: " + str(float(total_number_of_rendered_views) / float(controller_action_count))
