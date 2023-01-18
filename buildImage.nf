#!/usr/bin/env nextflow

params.image    = "casa"
params.tag      = 6.5


process buildImage {
    input:
        val  arch 
        path folder
    output:
        stdout

    """
    cd $folder
    podman build -t ${params.image}:${params.tag}-${arch} -f alma9-slim/Dockerfile --build-arg arch=${arch} .
    """
}

workflow {
    def arch = Channel.of("znver3")
    buildImage(arch, projectDir) | view
}
