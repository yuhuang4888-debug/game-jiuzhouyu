/** 时装用
 */
declare interface ProtoFmtInfo {
    41300: {
        desc: "打开时装界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            pos_list: {
                /** 位置id */
                pos_id: number;
                /** 穿着时装id */
                wear_fashion_id: number;
                /** 部位等级 */
                pos_lv: number;
                /** 时装部位当前经验值 */
                pos_upgrade_num: number;
                /** 已激活的时装id */
                fashion_list: {
                    /** 时装id */
                    fashion_id: number;
                    /** 当前颜色星数 */
                    fashion_star_lv: number;
                    /** 当前颜色 */
                    now_color_id: number;
                    /** 已激活颜色id映射星数列表 */
                    color_list: {
                        /** 颜色id */
                        color_id: number;
                        /** 星数 */
                        fashion_star_lv: number;
                    }[];
                }[];
            }[];
        };
    };
    41301: {
        desc: "染色/解锁颜色";
        send: (
            number: 41301,
            fmt: "cicc",
            args: [
                /**位置id*/
                pos_id: number,
                /**时装id*/
                fashion_id: number,
                /**颜色id*/
                color_id: number,
                /**1染色 2解锁*/
                type: number
            ]
        ) => never;
        sendFmt: "cicc";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            /**时装id*/
            fashion_id: number,
            /**颜色id*/
            color_id: number,
            /**1染色 2解锁*/
            type: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 时装id */
            fashion_id: number;
            /** 颜色id */
            color_id: number;
            /** 1染色 2解锁 */
            type: number;
        };
    };
    41302: {
        desc: "穿戴";
        send: (
            number: 41302,
            fmt: "cic",
            args: [
                /**位置id*/
                pos_id: number,
                /**时装id*/
                fashion_id: number,
                /**颜色id*/
                color_id: number
            ]
        ) => never;
        sendFmt: "cic";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            /**时装id*/
            fashion_id: number,
            /**颜色id*/
            color_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 时装id */
            fashion_id: number;
            /** 颜色id */
            color_id: number;
        };
    };
    41303: {
        desc: "卸下";
        send: (
            number: 41303,
            fmt: "ci",
            args: [
                /**位置id*/
                ipos_id: number,
                /**时装id*/
                fashion_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**位置id*/
            ipos_id: number,
            /**时装id*/
            fashion_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 时装id */
            fashion_id: number;
        };
    };
    41304: {
        desc: "激活时装";
        send: (
            number: 41304,
            fmt: "ci",
            args: [
                /**位置id*/
                pos_id: number,
                /**时装id*/
                fashion_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            /**时装id*/
            fashion_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 时装id */
            fashion_id: number;
        };
    };
    41305: {
        desc: "部位升级";
        send: (
            number: 41305,
            fmt: "cA",
            args: [
                /**位置id*/
                pos_id: number,
                goods_list: any
            ]
        ) => never;
        sendFmt: "cA";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            goods_list: any
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 部位等级 */
            pos_lv: number;
            /** 时装部位当前经验值 */
            pos_upgrade_num: number;
        };
    };
    41306: {
        desc: "时装进阶";
        send: (
            number: 41306,
            fmt: "cic",
            args: [
                /**位置id*/
                pos_id: number,
                /**时装id*/
                fashion_id: number,
                /**颜色id*/
                color_id: number
            ]
        ) => never;
        sendFmt: "cic";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            /**时装id*/
            fashion_id: number,
            /**颜色id*/
            color_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 时装id */
            fashion_id: number;
            /** 颜色id */
            color_id: number;
            /** 星数 */
            fashion_star_lv: number;
        };
    };
    41307: {
        desc: "时装精华变化通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 位置id */
            pos_id: number;
            /** 时装部位当前经验值 */
            pos_upgrade_num: number;
        };
    };
    41310: {
        desc: "单个时装信息";
        send: (
            number: 41310,
            fmt: "ci",
            args: [
                /**位置id*/
                pos_id: number,
                /**时装id*/
                fashion_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            /**时装id*/
            fashion_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 时装id */
            fashion_id: number;
            /** 星数 */
            fashion_star_lv: number;
            /** 当前颜色 */
            color_id: number;
            /** 已激活颜色id列表 */
            color_list: {
                /** 颜色id */
                color_id: number;
            }[];
        };
    };
    41311: {
        desc: "时装更换广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            fashion_equip: {
                /** 部位 */
                part_pos: number;
                /** 部位模型id */
                fashion_model_id: number;
                /** 颜色id */
                fashion_chartlet_id: number;
            }[];
        };
    };
    41312: {
        desc: "单个时装真实战力";
        send: (
            number: 41312,
            fmt: "ci",
            args: [
                /**位置id*/
                pos_id: number,
                /**时装id*/
                fashion_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            /**时装id*/
            fashion_id: number
        ];
        recv: {
            /** 位置id */
            pos_id: number;
            /** 时装id */
            fashion_id: number;
            /** 颜色已激活时为0，未激活时为预期战力 */
            color_power_list: {
                color_id: number;
                color_power: number;
                /** 下一阶的战力(0表示未激活或最高阶) */
                next_color_power: number;
            }[];
        };
    };
    41313: {
        desc: "时装套装信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            fashion_suit: {
                /** 套装Id */
                suit_id: number;
                /** 套装阶级 */
                lv: number;
                /** 已激活数量 */
                active_num: number;
                /** 可激活数量 */
                conform_num: number;
                /** 战力 */
                power: number;
                /** 下一阶战力 */
                next_power: number;
            }[];
        };
    };
    41314: {
        desc: "时装套装激活";
        send: (
            number: 41314,
            fmt: "cc",
            args: [
                /**套装Id*/
                suit_id: number,
                /**选择激活两件套或四件套*/
                active_num: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**套装Id*/
            suit_id: number,
            /**选择激活两件套或四件套*/
            active_num: number
        ];
        recv: {
            /** 套装Id */
            suit_id: number;
            /** 选择激活两件套或四件套 */
            active_num: number;
            /** 返回码 */
            code: number;
            /** 战力 */
            power: number;
            /** 下一阶战力 */
            next_power: number;
        };
    };
    41315: {
        desc: "时装套装升阶";
        send: (
            number: 41315,
            fmt: "c",
            args: [
                /**套装Id*/
                suit_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**套装Id*/
            suit_id: number
        ];
        recv: {
            /** 套装Id */
            suit_id: number;
            /** 套装阶级 */
            lv: number;
            /** 返回码 */
            code: number;
            /** 战力 */
            power: number;
            /** 下一阶战力 */
            next_power: number;
        };
    };
    41316: {
        desc: "染色升星";
        send: (
            number: 41316,
            fmt: "cic",
            args: [
                /**位置id*/
                pos_id: number,
                /**时装id*/
                fashion_id: number,
                /**颜色id*/
                color_id: number
            ]
        ) => never;
        sendFmt: "cic";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            /**时装id*/
            fashion_id: number,
            /**颜色id*/
            color_id: number
        ];
        recv: {
            /** 位置id */
            pos_id: number;
            /** 时装id */
            fashion_id: number;
            /** 颜色id */
            color_id: number;
            /** 颜色星级 */
            lv: number;
            /** 返回码 */
            code: number;
        };
    };
}
