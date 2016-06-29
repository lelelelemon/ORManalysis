import sys, os, fnmatch, re

if len(sys.argv) != 4:
    print("Usage: python next-action-overlap.py render_mapping_file app_views_folder next_actions_folder")
    exit(-1)


render_mapping_file = sys.argv[1]
app_views_folder = sys.argv[2]
next_actions_folder = sys.argv[3]

# get a dict of what views to be rendered under a controller action
render_mapping = {}
with open(render_mapping_file, "rb") as f:
    for line in f:
        line = line.split()
        if line[0] == "START:":
            curr_action = line[1]
            render_mapping[curr_action] = []
        elif line[0] == "RENDER:":
            curr_view = line[1]
            render_mapping[curr_action].append(curr_view)

#print(render_mapping)

#get a dict of how many lines each view file contains
view_lines = {}
for root, dirnames, filenames in os.walk(app_views_folder):
    for filename in fnmatch.filter(filenames, "*.rb"):
        fname = os.path.join(root, filename)
#        print fname
        num_lines = sum(1 for line in open(fname, "r"))
        fname = fname.replace(app_views_folder, "")
        fname = fname.replace("/", "_")
        fname = fname.split(".")[0]
#        print app_folder
        view_lines[fname] = num_lines
print(view_lines)

#get next actions
next_action_mapping = {}
# {curr_action1: [next_action1, next_action2, ...], curr_action2: [next_action1, next_action2, ...]...}
for root, dirnames, filenames in os.walk(next_actions_folder):
    for filename in filenames:
        fname = os.path.join(root, filename)
        curr_action = fname.replace(next_actions_folder, "").split(".")[0].split("(")[0].replace("Controller", "").lower()
        next_action_mapping[curr_action] = []
        with open(fname, "rb") as f:
            for line in f:
                next_action = line.replace("\n", "").replace(",", "_").replace("::", "/")
                next_action_mapping[curr_action].append(next_action)

#print(next_action_mapping)
#for curr_action in next_action_mapping:
#    print(curr_action)


total_lines_code = 0
overlap_lines_code = 0
total_views = 0
overlap_views = 0
for curr_action in next_action_mapping:
    if not curr_action in render_mapping:
        print(curr_action)
        continue
    for next_action in next_action_mapping[curr_action]:
        if not next_action in render_mapping:
            print(next_action)
            continue 
        curr_action_views = render_mapping[curr_action]
        next_action_views = render_mapping[next_action]

        total_count_next_action_views = len(next_action_views)
        overlap_count_next_action_views = 0
        
        total_count_lines_next_action_views = 0
        overlap_count_lines_next_action_views = 0


        for view in next_action_views:
            if not view in view_lines:
                continue
            total_count_lines_next_action_views += view_lines[view]
            if view in curr_action_views:
                overlap_count_next_action_views += 1
                overlap_count_lines_next_action_views += view_lines[view]
        if total_count_next_action_views != 0 and total_count_lines_next_action_views != 0:
            percentage_view_file_overlap = float(overlap_count_next_action_views) / float(total_count_next_action_views)
            percentage_view_file_overlap_lines = float(overlap_count_lines_next_action_views) / float(total_count_lines_next_action_views)
        else:
            percentage_view_file_overlap = 0.0
            percentage_view_file_overlap_lines = 0.0
#        print("number of files overlap: " + str(percentage_view_file_overlap) + " # " + curr_action + " --> " + next_action)
#        print("lines of code overlap: " + str(percentage_view_file_overlap_lines) + " # " + curr_action + " --> " + next_action)
        total_lines_code += total_count_lines_next_action_views
        overlap_lines_code += overlap_count_lines_next_action_views
        total_views += total_count_next_action_views
        overlap_views += overlap_count_next_action_views

print("total number of files overlap: " + str(float(overlap_views)/float(total_views)))
print("total number of lines of code overlap: " + str(float(overlap_lines_code)/float(total_lines_code)))
