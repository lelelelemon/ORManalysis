
for filename in `ls $1`; do
  echo $1$filename
  echo "number of controller actions"
  num_actions=`cat $1$filename | grep "START" | wc -l`
  echo $num_actions
  echo "number of view files rendered"
  num_renders=`cat $1$filename | grep "RENDER" | wc -l`
  echo $num_renders
  echo "average: "
  bc -l <<< "scale=2; $num_renders/$num_actions"

done
