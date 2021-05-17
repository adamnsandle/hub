#!/bin/bash
set -e
. ~/miniconda3/etc/profile.d/conda.sh
conda activate base

ALL_FILE=$(find *.md ! -name README.md)
TEMP_PY="temp.py"
CUDAS="nvidia"

for f in $ALL_FILE
do
  echo "Running pytorch example in $f"
  # FIXME: NVIDIA models checkoints are on cuda
  if [[ $f = $CUDAS* ]]; then
    echo "...skipped due to cuda checkpoints."
  elif [[ $f = "pytorch_fairseq_translation"* ]]; then
    echo "...temporarily disabled"
  # FIXME: torch.nn.modules.module.ModuleAttributeError: 'autoShape' object has no attribute 'fuse'
  elif [[ $f = "ultralytics_yolov5"* ]]; then
    echo "...temporarily disabled"
  # FIXME: cannot download https://s3.us-west-1.wasabisys.com/resnest/torch/resnest50-528c19ca.pth
  elif [[ $f = "pytorch_vision_resnest"* ]]; then
    echo "...temporarily disabled"
  else
    sed -n '/^```python/,/^```/ p' < $f | sed '/^```/ d' > $TEMP_PY
    python $TEMP_PY

    if [ -f "$TEMP_PY" ]; then
      rm $TEMP_PY
    fi
  fi
done
