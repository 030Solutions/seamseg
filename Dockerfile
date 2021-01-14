FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-devel
Add . /seamseg/
WORKDIR /seamseg/
RUN ls -lh /usr/local/
RUN pip install --upgrade pip
RUN pip install --ignore-installed --upgrade certifi 
RUN pip install pillow numpy umsgpack tqdm scikit-image pycocotools \
    git+git://github.com/waspinator/pycococreator.git@0.2.0 \
    git+https://github.com/mapillary/inplace_abn.git
RUN pip install -e .
WORKDIR /seamseg/scripts
RUN echo "# /bin/bash\nrsync -a -f"+ */" -f"- *" /mnt/Festpladder/datasets/riegel/Imagery_no_pano/ /mnt/Festpladder/datasets/riegel/imagery_semantic/\npython -m torch.distributed.launch --nproc_per_node=1  test_panoptic.py --meta ../saved_models/metadata.bin --log_dir ../log_dir ../saved_models/config.ini ../saved_models/seamseg_r50_vistas.tar ../input_data/ ../output_data/" > run.sh
RUN chmod 777 ./run.sh
#RUN pip install -r requirements.txt
# python command
#python -m torch.distributed.launch --nproc_per_node=1 test_panoptic_write_classes.py --meta ../saved_models/metadata.bin --log_dir ../log_dir ../saved_models/config.ini ../saved_models/seamseg_r50_vistas.tar ../input_data/ ../output_data/

# docker command
#docker run --ipc=host  --runtime=nvidia -it -v /mnt/Festpladder/datasets/riegel/imagery_no_pano/:/seamseg/input_data/ -v /mnt/Festpladder/datasets/riegel/imagery_semantic/:/seamseg/output_data --rm seamseg /bin/bash
