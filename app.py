import click
from models.fpska import Fpska
from functions.fpska_controller import FpskaController


@click.command()
@click.argument('mode', required=True)
@click.argument('inputfile', required=True, type=click.Path())
@click.option('--verbose', required=False, is_flag=True, help='Increase verbosity')
@click.option('--log', required=False, type=click.Path(), help='Save output to log file')
def cli(mode, verbose, log, inputfile):
    """
    \b
    mode: run|info|check|extract|merge
    run - convert video to 60fps
    info - get information about videofile
    extract - extract audio, video, subtitles
    merge - combine 60fps video, audio, subtitles into mkv

    inputfile - path to input video
    """

    appargs = {}
    appargs['mode'] = mode
    appargs['verbose'] = verbose
    appargs['log'] = log
    appargs['inputfile'] = inputfile
    return appargs


if __name__ == '__main__':
    app_args = cli(standalone_mode=False)

    fpska = Fpska(**app_args)

    fpska_controller = FpskaController(fpska)

    fpska.print()

#    fpska_controller.start()

