# W O M O D E L S

```text
+------------------------------------------------------------------+
|                                                                  |
|    Practical models for keyboards, desks, and other projects.    |
|                                                                  |
|    Source files  /  Printable parts  /  Room to tinker           |
|                                                                  |
+------------------------------------------------------------------+
```

This repository is a growing workshop for useful, buildable designs. Each
model lives in its own directory with its editable source and build steps.

## Models

| Model | What it is | Source |
| --- | --- | --- |
| Go60 Perch | Keyboard positioning base with a centered phone cradle | [go60/go60_perch.scad](go60/go60_perch.scad) |

More models, print files, renders, and notes will be added over time.

## Build the Go60 Perch

Requirements: [OpenSCAD](https://openscad.org/) and `make`.

```sh
cd go60
make
```

The default build exports a rendered PNG and an STL to `go60/build/`.

```sh
make preview  # quick preview image
make stl      # STL export
make 3mf      # 3MF export
make view     # open in the OpenSCAD GUI
make clean    # remove generated files
```

From the repository root, for example, run `make -C go60 stl`.

## Repository map

```text
.
|-- go60/
|   |-- go60_perch.scad   # editable model
|   |-- Makefile          # render and export targets
|   `-- build/            # generated files
|-- LICENSE
`-- README.md
```

## Adding a model

Give each design its own directory. Keep its editable source and build steps
with the model, and put generated exports in that model's `build/` directory.
Add the model to the table above so it is easy to find.

## License

See [LICENSE](LICENSE).
