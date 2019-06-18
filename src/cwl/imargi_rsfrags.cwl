#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/imargi:v1.1.1"

- class: "InlineJavascriptRequirement"

inputs:
  ref_genome:
    type: File
    inputBinding:
      separate: true
      prefix: "-r"
      position: 1

  chromsizes:
    type: File
    inputBinding:
      separate: true
      prefix: "-c"
      position: 2

  enzyme_name:
    type: string
    inputBinding:
      separate: true
      prefix: "-e"
      position: 3

  cut_position:
    type: int
    inputBinding:
      separate: true
      prefix: "-C"
      position: 4

  outdir:
    type: string
    inputBinding:
      separate: true
      prefix: "-o"
      position: 5
      default: "."

outputs:
  rsfrags_file:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/' + '*frags_bed.gz')"


baseCommand: ["imargi_rsfrags.sh"]
