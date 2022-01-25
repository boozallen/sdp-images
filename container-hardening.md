# Container Hardening Guide

Container hardening is the process of utilizing container
scanning tools to detect possible CVEs (Common Vulnerabilities & Exposures) 
and remediating them to minimize the attack surface of a container. 
Each individual, organization, or other entity may form their own requirements 
for this process and its outputs based on their needs and risk tolerance.
Below is an example:

> We are building a web server container using [Apache HTTP](https://httpd.apache.org/) version 2.4.48 as the server. 
> Once built, we analyzed the container with a scanning tool (Anchore, Twistlock, Snyk, etc.) 
> and detected [CVE-2021-39275](https://nvd.nist.gov/vuln/detail/CVE-2021-39275) was present. 
> After reviewing the CVE, we decided to upgrade the Apache HTTP server to the newer version 2.4.51 
> in order to prevent the vulnerability from being exploited and remove the threat from the container.

*Note: repository layout information and common container commands are available in the [SDP-Images README](./README.rst)*

## Solutions Delivery Platform (SDP) and Container Hardening

The hardening process undertaken for the containers of this repository is 
aligned to the [Iron Bank hardening process](https://repo1.dso.mil/dsop/dccscr/-/tree/master).
This allows for containers offered by this repository to receive comparatively 
the same degree of hardening provided to containers being used across the 
United States Department of Defense (US DoD).
Containers that have been fully hardened can be found in the
Repo One [SDP repository](https://repo1.dso.mil/dsop/solutions-delivery-platform) and
[Jenkinsfile-Runner repository](https://repo1.dso.mil/dsop/opensource/jenkins/jenkinsfile-runner). 
Additionally, the full breakdown of our hardening process is as follows, 
with the assumption that a given application has been containerized:

1. Identify all dependencies required for the application and gather them in a tarball
    1. This includes any .jar, .rpm, .whl, or other packages/files needed for the application in the container to function
    2. Packaging dependencies in this manner allows for this step to be automated,
    and will allow containers to be built in environments without external network connections
    3. An example of a container following this pattern is Jenkins, examine the [prebuild](/jenkins/kubernetes/prebuild/) 
    folder for setting up scripts automating this process, 
    and the [Makefile](/jenkins/kubernetes/Makefile) for stringing scripts together
    > To use Make CLI functions in a terminal, type `make`
    > followed by a subcommand from the Makefile.
    > For example, to run the tarball creation automation, type `make build-dep`.
    > At this time, creation of the tarball requires both the BAH-Public & BAH-Private keys.
    > See a repository administrator should you need to perform this action.
2. Build and test the container for expected performance
    1. Upgrading or modifying components of a container may cause intended functionality 
    of a given container to break, detecting this early helps reduce user impact
    2. To build a container, follow your installed container tool's manual
    > Using Docker for example, use `docker build --no-cache -t example-container:example-tag .`
    3. Testing the functionality of a container for expected behavior
    is unique to each container and the applications they house -
    read any provided documentation for each application and how it should be deployed
    4. Each container should provide instructions for how to use or deploy it
3. Create a release on GitHub hosting the dependency tarball
    1. Hosting the dependency tarball allows users to modify, build, and 
    test containers in their own environments, including Iron Bank
    2. To create a release:
    > - Create a tarball described in step 1
    > - Sign in to your GitHub account that has administrative privileges to the **SDP Images** repository
    > - Navigate to the [releases section](https://github.com/boozallen/sdp-images/releases)
    > - Select the **Draft a new release** button
    > - Follow the DCAR naming convention shown on the releases page, upload the tarball, sha256, and sig files, and select **Publish release**
4. Port updates to the Iron Bank repository for the respective container to use the new dependency tarball
    1. This includes creating a feature branch and updating the 
    [hardening manifest](https://repo1.dso.mil/dsop/dccscr/-/tree/master/hardening%20manifest), 
    Dockerfile, README, configuration or other supporting files
    2. Login to [Repo One](https://repo1.dso.mil/)
    (you will need to [register](https://login.dso.mil/auth/realms/baby-yoda/protocol/openid-connect/registrations?client_id=account&response_type=code)
    if you don't already have a Platform One account)
    3. Request access to the respective repository by using the **Request Access** link
    to the right of project ID underneath the name of the repository 
    at the top of the webpage if you don't have access to make changes
5. Run the updates through the Iron Bank container hardening pipeline
    1. This will typically be triggered automatically when changes are pushed to a 
    given branch of the container repository, but can be triggered manually as well 
    in the **CI/CD -> Pipelines** section of the repository
6. Review the scan results for offending CVE or compliance findings
    1. Can be located as an Excel spreadsheet in the **csv-output** job artifact
    archive or displayed in the **check-cves** job of the pipeline
7. Remediate all possible findings, repeating steps 1 through 6 as necessary
    1. Each CVE can be searched for on the internet for their description and 
    possible patches or mitigation steps for their resolution, most notably
    via the [National Vulnerability Database](https://nvd.nist.gov/vuln/search)
    2. Each compliance finding will have their description and possible patch 
    defined in the Excel spreadsheet mentioned in step 6
    3. The most common remediation techniques include, but are not limited to:
    updating packages to newer versions, removing packages, and applying 
    system adminstration (ex. chmod a file to be used only by authorized users) to the container
8. Submit justifications to the Iron Bank container hardening team for any non remediable CVE or compliance findings
    1. In the Excel spreadsheet described in step 6, provide a written justification
    in the `justification` column for the correlating CVE row
    2. The Iron Bank provides guidance for creating justifications under
    the **Contributors** section [here](https://repo1.dso.mil/dsop/dccscr/-/tree/master)
    3. Select the **Issues** tab in the Iron Bank container repository, and append the justifications to the appropriate issue
    4. Open a merge request via the **Merge requests** tab in the Iron Bank 
    container repository to merge your feature branch to the development branch, 
    and link the merge request to the corresponding issue
    5. Iron Bank will provide a determination if further action is required

## Iron Bank Notes

This section will provide additional details regarding Repo One, Iron Bank, 
and other services related to containers at Platform One.

[Repository Structure](https://repo1.dso.mil/dsop/dccscr/-/blob/master/Hardening/structure_requirements.md)

The folder structure for a given container repository is kept up 
to date at the above link, but follows the general pattern as follows below.

Required Folder Structure:

    container-project (feature-branch)
    │                             
    ├── Dockerfile                     (required)
    ├── hardening_manifest.yaml        (required)
    ├── LICENSE                        (required)
    ├── README.md                      (required)
    ├── renovate.json                  (file to be created if needed)
    ├── config/                        (directory to be created if needed)
    ├── documentation/                 (directory to be created if needed)
    ├── scripts/                       (directory to be created if needed)
    └── .gitlab/                       (created by default)

- Dockerfile: The instruction [file](https://repo1.dso.mil/dsop/dccscr/-/blob/master/Hardening/Dockerfile_Requirements.md) 
> used to build the container.
- hardening_manifest.yaml: [File](https://repo1.dso.mil/dsop/dccscr/-/tree/master/hardening%20manifest) 
> containing meta data for the container.
- LICENSE: The legal license file associated with the container.
- README.md: An introductory writeup of the container. 
> [More info found here](https://repo1.dso.mil/dsop/dccscr/-/blob/master/Hardening/structure_requirements.md)
- renovate.json: Optional file for setting up further automation of the repo.
- config/: Folder for keeping configuration files in one place.
- documentation/: Folder keeping additional documenation in one place.
- scripts/: Folder for keeping any scripts in one place.
- .gitlab/: Default folder containing templates for gitlab issues.