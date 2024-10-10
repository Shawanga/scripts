"""
Convert an image to a different format.
Usage: python3 converter.py /input_path.webp [-jpg] [-png] [-webp] [-s SIZE] [-o OUTPUT] [-v]

Author: Yana Nesterenko
"""

import argparse
import os
from PIL import Image


parser = argparse.ArgumentParser(prog="converter",
                                 description="Convert an image to a different format",
                                 usage="python3 converter.py /input_path.webp [-jpg] [-png] "
                                       "[-webp] [-s SIZE] [-o OUTPUT] [-v]",
                                 epilog="Thanks for using the script!")
parser.add_argument("path", help="Path to the input image file.")
parser.add_argument("-jpg", "--jpeg", action="store_true", help="Convert the image to JPEG format.")
parser.add_argument("-png", action="store_true", help="Convert the image to PNG format.")
parser.add_argument("-webp", action="store_true", help="Convert the image to WebP format.")
parser.add_argument("-s", "--size", nargs=2, type=int, help="Size of the output image.")
parser.add_argument("-o", "--output", help="Path to the output image file.")
parser.add_argument("-v", "--verbose", action="store_true", help="Increase output verbosity.")

args = parser.parse_args()


def convert_image(path, output, size, file_format):
    """
    Convert a file to a different format.
    """
    image = Image.open(path)
    if size:
        image = image.resize(size)
    image.save(output, format=file_format)
    return output

if __name__== "__main__":
    args = parser.parse_args()

    output_format = None

    if args.jpeg:
        output_format = "JPEG"
    elif args.png:
        output_format = "PNG"
    elif args.webp:
        output_format = "WebP"
    else:
        print("Please specify image output format.")
        exit(1)

    output_path = args.output
    if not output_path:
        output_path = os.path.splitext(args.path)[0] + f"_converted.{output_format.lower()}"

    if args.verbose:
        print(f"Converting {args.path} to {output_path} with format {format} and size {args.size if args.size else 'original'}")

    convert_image(args.path, output_path, tuple(args.size) if args.size else None, output_format)

    if args.verbose:
        print(f"Conversion successful. Image saved as {output_path}")
