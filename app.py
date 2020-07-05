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
    app_args = {}
#    click.echo(mode)
#    click.echo(verbose)
#    click.echo(log)
    app_args['mode'] = mode
    app_args['verbose'] = verbose
    app_args['log'] = log
    return app_args


if __name__ == '__main__':
    app_args = cli(standalone_mode=False)

    fpska = Fpska(**app_args)

    fpska_controller = FpskaController(fpska)

    fpska.print()

#    fpska_controller.start()

