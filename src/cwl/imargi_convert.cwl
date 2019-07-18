#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/imargi:v1.1.1_dcic_2"

- class: "InlineJavascriptRequirement"

inputs:
  out_format:
    type: string
    inputBinding:
      separate: true
      prefix: "-f"
      position: 1
    default: "cool"

  pairs_file:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"
      position: 3

  out_file:
    type: string
    inputBinding:
      separate: true
      prefix: "-o"
      position: 4
    default: "out.cool"

outputs:
  mcool_file:
    type: File
    outputBinding:
      glob: "$('*.mcool')"

baseCommand: ["imargi_convert.sh"]
