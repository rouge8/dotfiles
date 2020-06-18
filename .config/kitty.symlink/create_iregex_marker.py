def main(args):
    return input("iregex to search for: ")


def handle_result(args, answer, target_window_id, boss):
    boss.create_marker
    window = boss.window_id_map.get(target_window_id)
    spec = ["iregex", "1", answer]
    if window is not None and spec:
        try:
            window.set_marker(spec)
        except Exception as err:
            boss.show_error('Invalid marker specification', str(err))
