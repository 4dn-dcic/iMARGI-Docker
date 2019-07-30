#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/imargi:v1.1.1_dcic_3"

- class: "InlineJavascriptRequirement"

inputs:
  pipeline_stats:
    type: File
    inputBinding:
      position: 1

  pairs_stats:
    type: File
    inputBinding:
      position: 2

  output_dir:
    type: string
    inputBinding:
      position: 3
    default: "."

outputs:
  qc_report:
    type: File
    outputBinding:
      glob: "$(inputs.output_dir + '/' + 'qc_report.json')"

baseCommand: ["imargi_single_pairs_qc.sh"]
