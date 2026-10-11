export class table {
    static insert<T>(list: T[], vo: T): void;
    static insert<T>(list: T[], vo: number, vo1: T): void;
    public static insert<T>(list: T[], vo, vo1?) {
        if (list && vo) {
            if (vo1) {
                list.splice(vo, 0, vo1);
            } else {
                list.push(vo);
            }
        }
    }

    public static find<T extends string | number>(list: T[], vo: T): number {
        if (list && vo && list.indexOf) {
            return list.indexOf(vo);
        } else {
            return -1;
        }
    }

    static remove<T>(list: T[]): T[];
    static remove<T>(list: T[], index: number): T;
    public static remove<T>(list: T[], index?: number) {
        if (list) {
            if (index != null) {
                return list.splice(index, 1);
            } else {
                return list.pop();
            }
        }
    }

    public static sort<T = any>(list: T[], func: (a: T, b: T) => boolean) {
        if (list) {
            list.sort((a, b) => {
                return func(a, b) ? -1 : 1;
            });
        }
    }

    public static unshift<T>(list: T[], vo: T) {
        if (list) {
            list.unshift(vo);
        }
    }

    public static splice<T>(list: T[], start_index: number, count: number) {
        if (list) {
            list.splice(start_index, count);
        }
    }

    public static reverse<T>(list: T[]): T[] {
        if (list) {
            return list.reverse();
        }
    }

    public static shift<T>(list: T[]): T {
        if (list) {
            return list.shift();
        }
    }
}

window["table"] = table
