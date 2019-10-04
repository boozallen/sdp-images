IMAGE=ubi-jenkins-master
IMAGE_DIR=jenkins-master
OUTPUT_DIR=$IMAGE_DIR/scan 

mkdir -p $OUTPUT_DIR 

# rm -rf $OUTPUT_DIR/** 

docker run \
    -v $(pwd):/images \
    --privileged \
    -v /usr/local/bin/docker:/usr/local/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    oscap-docker oscap-docker image $IMAGE \
    xccdf eval \
    --results /images/$OUTPUT_DIR/remediated-scan-results.xml \
    --report /images/$OUTPUT_DIR/remediated-report.html \
    --profile xccdf_org.ssgproject.content_profile_stig-rhel7-disa \
    /usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml 

# sleep 5

# docker run \
#     -v $(pwd):/images \
#     --privileged \
#     -v /usr/local/bin/docker:/usr/local/bin/docker \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     oscap-docker oscap xccdf generate \
#     --profile xccdf_org.ssgproject.content_profile_stig-rhel7-disa \
#     fix --output /images/$OUTPUT_DIR/remediate.sh \
#      /images/$OUTPUT_DIR/scan-results.xml
