import sys, os, fnmatch

log_file = sys.argv[1]
app_folder = sys.argv[2]

view_lines = {}
for root, dirnames, filenames in os.walk(app_folder):
    for filename in fnmatch.filter(filenames, "*.erb"):
        fname = os.path.join(root, filename)
        num_lines = sum(1 for line in open(fname, "r"))
        view_lines[fname] = num_lines
        fname = fname.split(".")[0]
        view_lines[fname] = num_lines

print view_lines
action_rendered_views_map = {}
next_action_pairs_map = {}
past_controller_action = ""

with open(log_file) as f:
    for line in f:
        if all(x in line for x in ["total_duration", "db_time", "view_runtime", "query_time", "query_in_view", "render_partial_time", "render_template_time"]):
            controller_action = line.strip().split()[0]
            if past_controller_action != "":
                if not past_controller_action in next_action_pairs_map.keys():
                    next_action_pairs_map[past_controller_action] = []
                next_action_pairs_map[past_controller_action].append(controller_action)
            past_controller_action = controller_action
            if not controller_action in action_rendered_views_map.keys():
                action_rendered_views_map[controller_action] = []
        elif "render_template" in line or "render_partial" in line:
            line = line.split(",")[1]
            line = line.split()
            for item in line:
                if item != "identifier:" and item != "layout:" and item != "text" and item != "template":
                    action_rendered_views_map[controller_action].append(item)


total_lines_in_views = 0
overlap_lines_in_views = 0
total_files_in_views = 0
overlap_files_in_views = 0

for curr_action in next_action_pairs_map:
    for next_action in next_action_pairs_map[curr_action]:
        curr_rendered_views = action_rendered_views_map[curr_action]
        next_rendered_views = action_rendered_views_map[next_action]
        total_next_rendered_views_count = len(next_rendered_views)

        overlap_next_rendered_views_count = 0
        total_lines_next_views = 0
        overlap_lines_next_views = 0
        for view in next_rendered_views:
            if not app_folder in view:
                view = app_folder + "views/" + view
            total_lines_next_views += view_lines[view]
            if view in curr_rendered_views:
                overlap_next_rendered_views_count += 1
                overlap_lines_next_views += view_lines[view]
        if overlap_next_rendered_views_count == 0:
            percentage = 0.0
            lines_percentage = 0.0
        else:
            percentage = float(overlap_next_rendered_views_count) / float(total_next_rendered_views_count)
            lines_percentage = float(overlap_lines_next_views) / float(total_lines_next_views)
        print "files percentage " + str(percentage) + " # " + curr_action + " --> " + next_action
        print "lines percentage " + str(lines_percentage) + " # " + curr_action + " --> " + next_action
        total_lines_in_views += total_lines_next_views 
        overlap_lines_in_views += overlap_lines_next_views
        total_files_in_views += total_next_rendered_views_count
        overlap_files_in_views += overlap_next_rendered_views_count

print "total percentage lines overlap: " + str(float(overlap_lines_in_views) / float(total_lines_in_views))
print "total percentage lines overlap: " + str(float(overlap_files_in_views) / float(total_files_in_views))
