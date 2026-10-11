/** 星宿
 */
declare interface ProtoFmtInfo {
    23200: {
        desc: "通用错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            error_code_args: string;
        };
    };
    23201: {
        desc: "星宿界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 总星数 */
            total_star: number;
            item_list: {
                /** 星宿id */
                page: number;
                /** 战力汇总 */
                power: number;
                /** 普通套装数量 */
                normal_num: number;
                /** 特殊套装数量 */
                special_num: number;
                attr: any;
                /** 是否激活 0否 1是 */
                is_active: number;
            }[];
        };
    };
    23202: {
        desc: "穿装备";
        send: (
            number: 23202,
            fmt: "lic",
            args: [
                /**物品唯一id*/
                goods_id: number,
                /**星宿id*/
                page: number,
                /**0否 1是 是否属性转移*/
                is_replace: number
            ]
        ) => never;
        sendFmt: "lic";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number,
            /**星宿id*/
            page: number,
            /**0否 1是 是否属性转移*/
            is_replace: number
        ];
        recv: {
            /** 物品唯一id */
            goods_id: number;
            /** 物品类型id */
            goods_type_id: number;
        };
    };
    23203: {
        desc: "脱装备";
        send: (
            number: 23203,
            fmt: "ic",
            args: [
                /**星宿id*/
                page: number,
                /**位置  0表示一键卸下*/
                pos: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**星宿id*/
            page: number,
            /**位置  0表示一键卸下*/
            pos: number
        ];
        recv: {
            /** 物品唯一id */
            goods_id: number;
            /** 物品类型id */
            goods_type_id: number;
        };
    };
    23204: {
        desc: "单个装备页总属性";
        send: (
            number: 23204,
            fmt: "i",
            args: [
                /**星宿id*/
                page: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**星宿id*/
            page: number
        ];
        recv: {
            /** 星宿id */
            page: number;
            attr: any;
        };
    };
    23205: {
        desc: "星级大师";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 等级 手动激活等级未必等于总星数 */
            level: number;
            /** 历史最高等级 */
            max_level: number;
            /** 总星数 */
            star: number;
            /** 星级大师总战力 */
            power: number;
        };
    };
    23206: {
        desc: "星级大师升级";
        send: (
            number: 23206,
            fmt: "h",
            args: [
                /**等级 手动激活等级未必等于总星数*/
                leve: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**等级 手动激活等级未必等于总星数*/
            leve: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 等级 手动激活等级未必等于总星数 */
            level: number;
            /** 星级大师总战力 */
            power: number;
        };
    };
    23207: {
        desc: "装备吞噬界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 等级 手动激活等级未必等于总星数 */
            level: number;
            /** 进度 */
            exp: number;
            /** 总战力 */
            power: number;
            /** 勾选品质 */
            color: number;
            /** 勾选吞噬装备的卓越星数 */
            star: number;
        };
    };
    23208: {
        desc: "装备吞噬更改勾选状态";
        send: (
            number: 23208,
            fmt: "cc",
            args: [
                /**勾选品质*/
                color: number,
                /**勾选吞噬装备的卓越星数*/
                star: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**勾选品质*/
            color: number,
            /**勾选吞噬装备的卓越星数*/
            star: number
        ];
        recv: {
            /** 勾选品质 */
            color: number;
            /** 勾选吞噬装备的卓越星数 */
            star: number;
            code: number;
        };
    };
    23209: {
        desc: "装备吞噬";
        send: (number: 23209, fmt: any, args: [goods_list: any]) => never;
        sendFmt: any;
        sendArgs: [goods_list: any];
        recv: {
            /** 等级 手动激活等级未必等于总星数 */
            level: number;
            /** 进度 */
            exp: number;
            /** 总战力 */
            power: number;
        };
    };
    23210: {
        desc: "强化界面";
        send: (
            number: 23210,
            fmt: "c",
            args: [
                /**装备类型*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备类型*/
            type_id: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** 下一强化大师等级 */
            stage: number;
            /** stage是否达到满级 */
            is_max: number;
            /** 强化属性加成 */
            buff: number;
            /** 装备列表 */
            equip_list: {
                equip_id: number;
                pos: number;
                lv: number;
            }[];
        };
    };
    23211: {
        desc: "强化";
        send: (
            number: 23211,
            fmt: "ccc",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number,
                /**装备孔*/
                pos: number,
                /**0强化，1一键强化*/
                type: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number,
            /**装备孔*/
            pos: number,
            /**0强化，1一键强化*/
            type: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** 装备位置 */
            pos: number;
            /** 0强化，1一键强化 */
            type: number;
            /** 强化属性加成 */
            buff: number;
            /** 当前等级 */
            lv: number;
        };
    };
    23212: {
        desc: "强化大师界面";
        send: (
            number: 23212,
            fmt: "c",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            master_list: {
                master_lv: number;
                /** 0未点亮，1可点亮， 2已点亮 */
                status: number;
            }[];
        };
    };
    23213: {
        desc: "强化大师点亮";
        send: (
            number: 23213,
            fmt: "c",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number
        ];
        recv: {
            code: number;
            /** 装备类型 */
            type_id: number;
            /** lv之前的都点亮 */
            master_lv: number;
        };
    };
    23220: {
        desc: "进化界面";
        send: (
            number: 23220,
            fmt: "c",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** 装备列表 */
            equip_list: {
                equip_id: number;
                pos: number;
                /** 进化等级 */
                lv: number;
                /** 卓越属性条数 */
                attr_num: number;
            }[];
        };
    };
    23221: {
        desc: "进化";
        send: (
            number: 23221,
            fmt: "clcA",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number,
                /**装备id    只有进化是绑定装备的，其余绑定装备格子*/
                equip_id: number,
                /**装备位置*/
                pos: number,
                /**消耗装备列表（添加成功率）*/
                equip_list: any
            ]
        ) => never;
        sendFmt: "clcA";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number,
            /**装备id    只有进化是绑定装备的，其余绑定装备格子*/
            equip_id: number,
            /**装备位置*/
            pos: number,
            /**消耗装备列表（添加成功率）*/
            equip_list: any
        ];
        recv: {
            code: number;
            /** 进化是否成功 0失败 1成功 */
            is_success: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** 装备id */
            equip_id: number;
            /** 装备位置 */
            pos: number;
            /** 等级 */
            lv: number;
            /** 获得卓越属性的id */
            attr_id: number;
        };
    };
    23230: {
        desc: "附魔界面";
        send: (
            number: 23230,
            fmt: "c",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** 下一附魔大师等级 */
            stage: number;
            /** stage是否达到满级 */
            is_max: number;
            /** 装备列表 */
            equip_list: {
                equip_id: number;
                pos: number;
                lv: number;
            }[];
        };
    };
    23231: {
        desc: "附魔";
        send: (
            number: 23231,
            fmt: "ccc",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number,
                /**装备位置*/
                pos: number,
                /**1消耗钻石购买不足的材料，0不消耗*/
                type: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number,
            /**装备位置*/
            pos: number,
            /**1消耗钻石购买不足的材料，0不消耗*/
            type: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** 装备位置 */
            pos: number;
            /** 1消耗钻石购买不足的材料，0不消耗 */
            type: number;
            /** 当前等级 */
            lv: number;
        };
    };
    23232: {
        desc: "附魔大师界面";
        send: (
            number: 23232,
            fmt: "c",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            master_list: {
                master_lv: number;
                /** 0未点亮，1可点亮， 2已点亮 */
                status: number;
            }[];
        };
    };
    23233: {
        desc: "附魔大师点亮";
        send: (
            number: 23233,
            fmt: "c",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** lv之前的都点亮 */
            master_lv: number;
        };
    };
    23240: {
        desc: "启灵界面";
        send: (
            number: 23240,
            fmt: "c",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** 装备列表 */
            equip_list: {
                equip_id: number;
                pos: number;
                /** 0未启灵，1已启灵 */
                is_spirit: number;
            }[];
        };
    };
    23241: {
        desc: "启灵";
        send: (
            number: 23241,
            fmt: "cc",
            args: [
                /**装备类型 等同于星宿id*/
                type_id: number,
                /**装备位置*/
                pos: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**装备类型 等同于星宿id*/
            type_id: number,
            /**装备位置*/
            pos: number
        ];
        recv: {
            code: number;
            /** 装备类型 等同于星宿id */
            type_id: number;
            /** 装备位置 */
            pos: number;
            /** 0未启灵，1已启灵 */
            is_spirit: number;
        };
    };
    23250: {
        desc: "tips";
        send: (
            number: 23250,
            fmt: "ll",
            args: [
                /**玩家id*/
                role_id: number,
                /**物品唯一id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**玩家id*/
            role_id: number,
            /**物品唯一id*/
            goods_id: number
        ];
        recv: {
            /** 物品唯一id */
            goods_id: number;
            /** 综合评分 */
            score: number;
            send_dsgt: {
                /** 词缀id */
                dsgt_id: number;
                /** 数量 */
                dsgt_num: number;
                dsgt_suit: any;
                dsgt_attr: any;
            }[];
            star_attr_cfg: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
                /** 每多少级增加(成长型属性使用) */
                plus_interval: number;
                /** 每隔多少级增加多少属性(成长型属性使用) */
                plus_unit: number;
                /** 颜色 参考后台颜色配置 */
                color: number;
                /** 星级 */
                type_id: number;
            }[];
            star_attr: any;
            /** 套装数量 */
            suit_num: number;
            suit_attr: any;
            base_attr: any;
            extra_attr: any;
            stren_attr: any;
            evolu_attr: any;
            master_attr: any;
            spirit_attr: any;
            /** 基础评分 */
            base_rating: number;
        };
    };
    23251: {
        desc: "星级大师星数改变";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 等级 手动激活等级未必等于总星数 */
            level: number;
            /** 历史最高等级 */
            max_level: number;
            /** 总星数 */
            star: number;
            /** 星级大师总战力 */
            power: number;
        };
    };
    23252: {
        desc: "合成";
        send: (
            number: 23252,
            fmt: "iAAA",
            args: [
                /**合成规则id*/
                rule_id: number,
                /**指定扣除物品(随机材料)*/
                irregular_glist: any,
                /**指定扣除物品(固定材料)*/
                regular_glist: any,
                /**指定扣除物品(增加成功率材料)*/
                ratio_glist: any
            ]
        ) => never;
        sendFmt: "iAAA";
        sendArgs: [
            /**合成规则id*/
            rule_id: number,
            /**指定扣除物品(随机材料)*/
            irregular_glist: any,
            /**指定扣除物品(固定材料)*/
            regular_glist: any,
            /**指定扣除物品(增加成功率材料)*/
            ratio_glist: any
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 合成规则id */
            rule_id: number;
            send_list: {
                /** 合成的物品id */
                goods_id: number;
                /** 合成的物品类型id */
                goods_type_id: number;
            }[];
        };
    };
    23253: {
        desc: "解锁星宿";
        send: (
            number: 23253,
            fmt: "i",
            args: [
                /**星宿id*/
                page: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**星宿id*/
            page: number
        ];
        recv: {
            page: number;
            /** 返回码 */
            code: number;
        };
    };
    23254: {
        desc: "属性转移预览";
        send: (
            number: 23254,
            fmt: "ll",
            args: [
                /**物品唯一id 被转移物品唯一id*/
                goods_id: number,
                /**转移目标物品唯一id*/
                target_id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**物品唯一id 被转移物品唯一id*/
            goods_id: number,
            /**转移目标物品唯一id*/
            target_id: number
        ];
        recv: {
            /** 物品唯一id */
            goods_id: number;
            /** 转移目标物品唯一id */
            target_id: number;
            /** 综合评分 */
            score: number;
            send_dsgt: {
                /** 词缀id */
                dsgt_id: number;
                /** 数量 */
                dsgt_num: number;
                dsgt_suit: any;
                dsgt_attr: any;
            }[];
            star_attr_cfg: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
                /** 每多少级增加(成长型属性使用) */
                plus_interval: number;
                /** 每隔多少级增加多少属性(成长型属性使用) */
                plus_unit: number;
                /** 颜色 参考后台颜色配置 */
                color: number;
                /** 星级 */
                type_id: number;
            }[];
            star_attr: any;
            /** 套装数量 */
            suit_num: number;
            suit_attr: any;
            base_attr: any;
            extra_attr: any;
            stren_attr: any;
            evolu_attr: any;
            master_attr: any;
            spirit_attr: any;
            /** 基础评分 */
            base_rating: number;
        };
    };
    23255: {
        desc: "tips";
        send: (
            number: 23255,
            fmt: "i",
            args: [
                /**物品类型id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            goods_id: number
        ];
        recv: {
            /** 物品类型id */
            goods_id: number;
            /** 综合评分 */
            score: number;
            send_dsgt: {
                /** 词缀id */
                dsgt_id: number;
                /** 数量 */
                dsgt_num: number;
                dsgt_suit: any;
                dsgt_attr: any;
            }[];
            star_attr_cfg: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
                /** 每多少级增加(成长型属性使用) */
                plus_interval: number;
                /** 每隔多少级增加多少属性(成长型属性使用) */
                plus_unit: number;
                /** 颜色 参考后台颜色配置 */
                color: number;
                /** 星级 */
                type_id: number;
            }[];
            star_attr: any;
            /** 套装数量 */
            suit_num: number;
            base_attr: any;
            extra_attr: any;
            /** 基础评分 */
            base_rating: number;
        };
    };
    23256: {
        desc: "合成次数统计";
        send: (
            number: 23256,
            fmt: "i",
            args: [
                /**合成id*/
                compose_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**合成id*/
            compose_id: number
        ];
        recv: {
            /** 合成id */
            compose_id: number;
            /** 总合成次数 */
            times: number;
            /** 合成X次获得稀有物品 */
            index: number;
            /** 总合成次数  合成X次获得稀有物品  8 - 余数 */
            num: number;
        };
    };
    23257: {
        desc: "属性转移=";
        send: (
            number: 23257,
            fmt: "ll",
            args: [
                /**物品唯一id 被转移物品唯一id（消耗品）*/
                goods_id: number,
                /**转移目标物品唯一id*/
                target_id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**物品唯一id 被转移物品唯一id（消耗品）*/
            goods_id: number,
            /**转移目标物品唯一id*/
            target_id: number
        ];
        recv: {
            /** 1 */
            res: number;
        };
    };
}
