/** 使魔
 */
declare interface ProtoFmtInfo {
    18300: {
        desc: "错误码信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协议号 */
            cmd: number;
            /** 错误码 */
            error_code: number;
            /**  参数 */
            args: string;
        };
    };
    18301: {
        desc: "激活的使魔列表(基础信息)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否当天打开过黑市 0否1是 */
            open_state: number;
            demons_list: {
                demons_id: number;
                /** 等级 */
                level: number;
                exp: number;
                /** 星数 */
                star: number;
                /** 已解锁槽位数量 */
                slot_num: number;
                skill_list: {
                    skill_id: number;
                    skill_lv: number;
                    /** 技能进度#生活技能专有 */
                    process: number;
                    /** 技能是否已激活 */
                    is_active: number;
                }[];
                slot_skill: {
                    sk_id: number;
                    sk_lv: number;
                    /** 槽位 */
                    slot: number;
                    /** 品质 */
                    quality: number;
                    /** 种类 */
                    sort: number;
                }[];
            }[];
        };
    };
    18302: {
        desc: "使魔战力";
        send: (number: 18302, fmt: "i", args: [demons_id: number]) => never;
        sendFmt: "i";
        sendArgs: [demons_id: number];
        recv: {
            demons_id: number;
            /** 使魔战力 */
            power: number;
        };
    };
    18303: {
        desc: "羁绊列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            fetters_list: {
                /** 羁绊id */
                fetters_id: number;
            }[];
        };
    };
    18304: {
        desc: "激活/升星";
        send: (number: 18304, fmt: "i", args: [demons_id: number]) => never;
        sendFmt: "i";
        sendArgs: [demons_id: number];
        recv: {
            code: number;
            demons_id: number;
            star: number;
            skill_list: {
                skill_id: number;
                skill_lv: number;
                /** 技能进度#生活技能专有 */
                process: number;
                /** 技能是否已激活 */
                is_active: number;
            }[];
            /** 使魔战力 */
            power: number;
            /** 已解锁槽位数量 */
            slot_num: number;
        };
    };
    18305: {
        desc: "升级";
        send: (number: 18305, fmt: "i", args: [demons_id: number]) => never;
        sendFmt: "i";
        sendArgs: [demons_id: number];
        recv: {
            code: number;
            demons_id: number;
            level: number;
            exp: number;
            /** 使魔战力 */
            power: number;
        };
    };
    18306: {
        desc: "使魔跟随";
        send: (number: 18306, fmt: "i", args: [demons_id: number]) => never;
        sendFmt: "i";
        sendArgs: [demons_id: number];
        recv: {
            code: number;
            demons_id: number;
        };
    };
    18307: {
        desc: "上卷信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            painting_get: {
                /** 已领取奖励的上卷id */
                painting_id: number;
            }[];
        };
    };
    18308: {
        desc: "领取上卷奖励";
        send: (
            number: 18308,
            fmt: "c",
            args: [
                /**上卷id*/
                painting_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**上卷id*/
            painting_id: number
        ];
        recv: {
            code: number;
            /** 上卷id */
            painting_id: number;
            rewards: any;
        };
    };
    18309: {
        desc: "升级使魔技能";
        send: (
            number: 18309,
            fmt: "ii",
            args: [demons_id: number, skill_id: number]
        ) => never;
        sendFmt: "ii";
        sendArgs: [demons_id: number, skill_id: number];
        recv: {
            code: number;
            demons_id: number;
            skill_id: number;
            new_level: number;
        };
    };
    18310: {
        desc: "使魔镶嵌/升级/替换天赋技能";
        send: (
            number: 18310,
            fmt: "ici",
            args: [
                /**使魔id*/
                demons_id: number,
                /**槽位*/
                slot: number,
                /**物品类型id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "ici";
        sendArgs: [
            /**使魔id*/
            demons_id: number,
            /**槽位*/
            slot: number,
            /**物品类型id*/
            goods_id: number
        ];
        recv: {
            demons_id: number;
            slot: number;
            skill_id: number;
            /** 品质 */
            quality: number;
            /** 种类 */
            sort: number;
            /** 失败返回0 */
            leve: number;
            /** 成功发1 */
            code: number;
        };
    };
    18311: {
        desc: "商城信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 固定刷新时间 */
            refresh_time: number;
            /** 刷新次数 */
            refresh_num: number;
            cost: any;
            shop: {
                /** 商品id */
                id: number;
                /** 物品类型id */
                goods_id: number;
                /** 价格类型 */
                price: number;
                /** 物品数量 */
                num: number;
                /** 原价 */
                cost_num: number;
                /** 折扣 1-9折 */
                discount: number;
                /** 可购买次数 */
                can_buy_num: number;
                /** 已购买次数 */
                buy_num: number;
            }[];
        };
    };
    18312: {
        desc: "商城购买";
        send: (
            number: 18312,
            fmt: "i",
            args: [
                /**商品id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**商品id*/
            id: number
        ];
        recv: {
            /** 商品id */
            id: number;
            /** 已购买次数 */
            buy_num: number;
            /** 返回码 */
            code: number;
        };
    };
    18313: {
        desc: "商城刷新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 再次刷新次数 */
            refresh_num: number;
            cost: any;
        };
    };
    18314: {
        desc: "查看技能真实战力";
        send: (
            number: 18314,
            fmt: "icih",
            args: [
                /**使魔id*/
                demons_id: number,
                /**0技能背包 1使魔槽位*/
                sign: number,
                /**如果是技能背包0发物品类型id;如果是已经镶嵌的技能则发技能id*/
                id: number,
                /**技能等级*/
                sk_lv: number
            ]
        ) => never;
        sendFmt: "icih";
        sendArgs: [
            /**使魔id*/
            demons_id: number,
            /**0技能背包 1使魔槽位*/
            sign: number,
            /**如果是技能背包0发物品类型id;如果是已经镶嵌的技能则发技能id*/
            id: number,
            /**技能等级*/
            sk_lv: number
        ];
        recv: {
            /** 战力 */
            power: number;
            /** 使魔id 只有sign = 1才有意义，否则服务端默认发0 */
            demons_id: number;
            /** 0技能背包 1使魔槽位 */
            sign: number;
            /** 技能id */
            sk_id: number;
            /** 技能等级 */
            sk_lv: number;
            /** 返回码 */
            code: number;
        };
    };
    18315: {
        desc: "当天第一次打开黑市时返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否当天打开过黑市 0否1是 */
            open_state: number;
        };
    };
    18316: {
        desc: "激活生活技能";
        send: (number: 18316, fmt: "i", args: [demons_id: number]) => never;
        sendFmt: "i";
        sendArgs: [demons_id: number];
        recv: {
            /** 返回码 */
            code: number;
            demons_id: number;
        };
    };
    18317: {
        desc: "激活生活技能进度变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            demons_id: number;
            skill_id: number;
            skill_lv: number;
            /** 技能进度#生活技能专有 */
            process: number;
            /** 技能是否已激活 */
            is_active: number;
        };
    };
}
