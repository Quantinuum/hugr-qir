from guppylang import guppy, qubit
from guppylang.std.platform import output
from guppylang.std.quantum import h, measure


@guppy
def main() -> None:
    input = qubit()
    h(input)
    r = measure(input)
    output("r", r.read())

    if r:
        output("true", True)
    else:
        output("false", True)


'''
Helios-1E Results:
QsysResult(results=[QsysShot(entries=[['true', 1]]), QsysShot(entries=[['false', 0]]), QsysShot(entries=[['true', 1]]), QsysShot(entries=[['false', 0]]), QsysShot(entries=[['false', 0]]), QsysShot(entries=[['false', 0]]), QsysShot(entries=[['false', 0]]), QsysShot(entries=[['false', 0]]), QsysShot(entries=[['true', 1]]), QsysShot(entries=[['false', 0]])])

H2-1E Results:
QsysResult(results=[
    QsysShot(entries=[('true', True), ('false', False)]),
    QsysShot(entries=[('true', False), ('false', False)]),
    QsysShot(entries=[('true', False), ('false', False)]),
    QsysShot(entries=[('true', False), ('false', False)]),
    QsysShot(entries=[('true', True), ('false', False)]),
    QsysShot(entries=[('true', True), ('false', False)]),
    QsysShot(entries=[('true', True), ('false', False)]),
    QsysShot(entries=[('true', True), ('false', False)]),
    QsysShot(entries=[('true', True), ('false', False)]), QsysShot(entries=[('true', False), ('false', False)])])

'''