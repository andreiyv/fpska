import click
from models.fpska import Fpska
from functions.fpska_controller import FpskaController


@click.command()
@click.option('--verbose', is_flag=True, help='Increases verbosity')
@click.option('--log', default='on', help='Saves output to log file')
@click.argument('mode')

def cli(mode, verbose, log):
    """
    \b
    mode: run|info|check|extract|merge
    run - convert video to 60fps
    info - get information about videofile
    check - make sure that all 3-rd party programs are installed
    extract - extract audio, video, subtitles
    merge - combine 60fps video, audio, subtitles into mkv
    """
#    click.echo(mode)
#    click.echo(verbose)
#    click.echo(log)
    return mode, verbose, log


if __name__ == '__main__':
    mode, verbose, log = cli(standalone_mode=False)

    fpska = Fpska(mode, verbose, log)

    fpska_controller = FpskaController(fpska)

    fpska_controller.print()

#    fpska_controller.start()

