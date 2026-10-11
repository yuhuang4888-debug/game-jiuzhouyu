/** 伙伴
 */
declare interface ProtoFmtInfo {
    41200: {
        desc: "获取伙伴列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 金钱招募免费时间戳 */
            coin_et: number;
            /** 金钱 剩余次数 */
            coin_tms: number;
            /** 元宝招募免费时间戳 */
            gold_et: number;
            /** 元宝 剩余次数 */
            gold_tms: number;
        };
    };
    41201: {
        desc: "获取伙伴基础信息同步28202协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            partners: {
                /** 伙伴唯一Id */
                id: number;
                /** 伙伴id */
                partnerid: number;
                /** 等级 */
                lv: number;
                /** 出战状态 */
                state: number;
                /** 出战列表中的位置 */
                pos: number;
                /** 战力 */
                combat: number;
                /** 奇才 */
                prodigy: number;
                weapon: number;
            }[];
        };
    };
    41202: {
        desc: "获取伙伴基础信息同步28203协议";
        send: (
            number: 41202,
            fmt: "l",
            args: [
                /**伙伴唯一id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**伙伴唯一id*/
            id: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            /** 伙伴唯一id */
            id: number;
            /** 伙伴id */
            partnerid: number;
            /** 等级 */
            lv: number;
            /** 经验值 */
            exp: number;
            /** 最大经验值 */
            maxexp: number;
            /** 突破状态 0 不可突破 1 可突破 */
            break_st: number;
            base_attr: {
                /** 属性类型 体质敏捷 */
                type: number;
                /** 当前值 */
                curval: number;
                /** 上限值 */
                uppval: number;
                /** 属性品质 */
                quality: number;
            }[];
            skill: {
                /** 技能书id */
                sk_book: number;
                /** 技能id */
                sk_id: number;
                /** 技能等级 */
                sk_lv: number;
                /** 技能位置 9 护主 10 天赋 */
                sk_pos: number;
            }[];
            /** 专属激活 0 未激活 >0已激活 */
            weapon: number;
            /** 战力 */
            combat: number;
            /** 奇才 */
            prodigy: number;
        };
    };
    41203: {
        desc: "获取伙伴二级属性信息同步28204协议";
        send: (
            number: 41203,
            fmt: "l",
            args: [
                /**id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**id*/
            id: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** id */
            id: number;
            /** 属性信息 */
            attr: any;
        };
    };
    41204: {
        desc: "洗髓推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** id */
            id: number;
            /** 战力 */
            combat: number;
            /** 奇才 */
            prodigy: number;
        };
    };
    41208: {
        desc: "使用卡片获取伙伴";
        send: (
            number: 41208,
            fmt: "i",
            args: [
                /**伙伴id*/
                partnerid: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**伙伴id*/
            partnerid: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** 唯一id */
            id: number;
            /** 伙伴id */
            partnerid: number;
            /** 等级 */
            lv: number;
            /** 出战状态 */
            state: number;
            /** 出战列表中的位置 */
            pos: number;
            /** 战力 */
            combat: number;
            /** 奇才 */
            prodigy: number;
            /** 专属激活 0 未激活 >0已激活 */
            weapon: number;
        };
    };
    41209: {
        desc: "招募";
        send: (
            number: 41209,
            fmt: "cc",
            args: [
                /**是否是10连招募*/
                ten_recruit: number,
                /**招募类型 1 金钱 2 元宝*/
                type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**是否是10连招募*/
            ten_recruit: number,
            /**招募类型 1 金钱 2 元宝*/
            type: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** 是否是10连招募 */
            ten_recruit: number;
            /** 招募类型 */
            type: number;
            partner_list: {
                /** 伙伴唯一Id */
                id: number;
                /** 伙伴id */
                partnerid: number;
                /** 等级 */
                lv: number;
                /** 出战状态 */
                state: number;
                /** 出战列表中的位置 */
                pos: number;
                /** 战力 */
                combat: number;
                /** 奇才 */
                prodigy: number;
                /** 专属激活 0 未激活 >0已激活 */
                weapon: number;
            }[];
            goods_list: {
                /** 物品类型id */
                goods_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    41210: {
        desc: "伙伴上/下阵";
        send: (
            number: 41210,
            fmt: "lc",
            args: [
                /**id*/
                id: number,
                /**1 上阵 2下阵*/
                opra: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**id*/
            id: number,
            /**1 上阵 2下阵*/
            opra: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** 伙伴上下阵的位置 */
            pos: number;
        };
    };
    41211: {
        desc: "获取升级药品数量";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            goods: {
                /** 物品id */
                id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    41212: {
        desc: "伙伴使用药品增加经验升级";
        send: (
            number: 41212,
            fmt: "lic",
            args: [
                /**伙伴唯一id*/
                id: number,
                /**使用的物品id*/
                goodsid: number,
                /**数量*/
                num: number
            ]
        ) => never;
        sendFmt: "lic";
        sendArgs: [
            /**伙伴唯一id*/
            id: number,
            /**使用的物品id*/
            goodsid: number,
            /**数量*/
            num: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** 伙伴唯一id */
            id: number;
            /** 等级 */
            lv: number;
            /** 当前经验值 */
            exp: number;
            /** 增加值 */
            add_exp: number;
        };
    };
    41214: {
        desc: "突破";
        send: (
            number: 41214,
            fmt: "l",
            args: [
                /**伙伴唯一id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**伙伴唯一id*/
            id: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** 伙伴唯一id */
            id: number;
            /** 突破状态 0 不可突破 1 可突破 */
            break_st: number;
            base_attr: {
                /** 属性类型 体质敏捷 */
                type: number;
                /** 当前值 */
                curval: number;
                /** 上限值 */
                uppval: number;
                /** 属性品质 */
                quality: number;
            }[];
        };
    };
    41215: {
        desc: "洗髓";
        send: (
            number: 41215,
            fmt: "l",
            args: [
                /**伙伴唯一id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**伙伴唯一id*/
            id: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            partners: {
                /** 0 洗髓前伙伴信息 1 洗髓后伙伴信息 */
                wash: number;
                /** 战力 */
                combat: number;
                /** 奇才 */
                prodigy: number;
                base_attr: {
                    /** 属性类型 体质敏捷 */
                    type: number;
                    /** 当前值 */
                    curval: number;
                    /** 上限值 */
                    uppval: number;
                    /** 属性品质 */
                    quality: number;
                }[];
                skill: {
                    /** 技能书id */
                    sk_book: number;
                    /** 技能id */
                    sk_id: number;
                    /** 技能等级 */
                    sk_lv: number;
                    /** 技能位置 */
                    sk_pos: number;
                }[];
            }[];
        };
    };
    41216: {
        desc: "洗髓保留";
        send: (
            number: 41216,
            fmt: "cl",
            args: [
                /**操作类型 0 保留 1 替换*/
                op: number,
                /**伙伴唯一id*/
                id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**操作类型 0 保留 1 替换*/
            op: number,
            /**伙伴唯一id*/
            id: number
        ];
        recv: {
            /** id */
            id: number;
            /** 战力 */
            combat: number;
            /** 奇才 */
            prodigy: number;
        };
    };
    41218: {
        desc: "获取布阵";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            embattle: {
                /** 位置 */
                pos: number;
                /** 类型 2 玩家 3 伙伴 */
                type: number;
                /** id */
                id: number;
                /** 类型id */
                partnerid: number;
                /** 等级 */
                lv: number;
            }[];
        };
    };
    41219: {
        desc: "改变布阵";
        send: (
            number: 41219,
            fmt: "cc",
            args: [
                /**原位置*/
                src_pos: number,
                /**目标位置*/
                dst_pos: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**原位置*/
            src_pos: number,
            /**目标位置*/
            dst_pos: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
        };
    };
    41220: {
        desc: "打开资质提升界面";
        send: (
            number: 41220,
            fmt: "l",
            args: [
                /**id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**id*/
            id: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            /** 拥有的资质丹数量 */
            num: number;
        };
    };
    41221: {
        desc: "资质提升";
        send: (
            number: 41221,
            fmt: "lcA",
            args: [
                /**id*/
                id: number,
                /**属性类型 体质敏捷*/
                attr_type: number,
                goods: any
            ]
        ) => never;
        sendFmt: "lcA";
        sendArgs: [
            /**id*/
            id: number,
            /**属性类型 体质敏捷*/
            attr_type: number,
            goods: any
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            /** id */
            id: number;
            /** 战力 */
            combat: number;
            add: {
                /** 增加值 */
                value: number;
            }[];
            /** 属性类型 体质敏捷 */
            attr_type: number;
            /** 当前值 */
            curval: number;
        };
    };
    41222: {
        desc: "获取可以学习的技能书";
        send: (
            number: 41222,
            fmt: "lc",
            args: [
                /**id*/
                id: number,
                /**学习技能填0，替换技能填被替换技能的技能品质*/
                color: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**id*/
            id: number,
            /**学习技能填0，替换技能填被替换技能的技能品质*/
            color: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            sk_list: {
                /** 物品id */
                id: number;
                /** 物品类型id */
                typeid: number;
                /** 数量 */
                num: number;
                /** 技能品质 */
                color: number;
            }[];
        };
    };
    41223: {
        desc: "学习/替换技能";
        send: (
            number: 41223,
            fmt: "licc",
            args: [
                /**id*/
                id: number,
                /**物品id*/
                goodsid: number,
                /**技能学习的位置*/
                pos: number,
                /**操作类型 1 学习 2 替换*/
                op: number
            ]
        ) => never;
        sendFmt: "licc";
        sendArgs: [
            /**id*/
            id: number,
            /**物品id*/
            goodsid: number,
            /**技能学习的位置*/
            pos: number,
            /**操作类型 1 学习 2 替换*/
            op: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            /** id */
            id: number;
            /** 技能书id */
            sk_book: number;
            /** 技能id */
            sk_id: number;
            /** 技能等级 */
            sk_lv: number;
            /** 技能位置 */
            pos: number;
            /** 战力 */
            combat: number;
        };
    };
    41224: {
        desc: "预览获取所有伙伴";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 伙伴id */
                partnerid: number;
                /** 专属激活 0 未激活 >0已激活 */
                weapon: number;
            }[];
        };
    };
    41225: {
        desc: "遣散";
        send: (number: 41225, fmt: any, args: [id_list: any]) => never;
        sendFmt: any;
        sendArgs: [id_list: any];
        recv: {
            /** 返回码，1成功 */
            code: number;
            goods_list: {
                /** 物品类型id */
                goods_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    41226: {
        desc: "召回";
        send: (
            number: 41226,
            fmt: "i",
            args: [
                /**伙伴id*/
                partnerid: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**伙伴id*/
            partnerid: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            /** 唯一id */
            id: number;
            /** 伙伴id */
            partnerid: number;
            /** 等级 */
            lv: number;
            /** 出战状态 */
            state: number;
            /** 出战列表中的位置 */
            pos: number;
            /** 战力 */
            combat: number;
            /** 奇才 */
            prodigy: number;
            /** 专属激活 0 未激活 >0已激活 */
            weapon: number;
        };
    };
    41227: {
        desc: "改变上阵位置";
        send: (
            number: 41227,
            fmt: "cc",
            args: [
                /**原位置*/
                src: number,
                /**目标位置*/
                dst: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**原位置*/
            src: number,
            /**目标位置*/
            dst: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            battlepos: {
                /** 伙伴id */
                id: number;
                /** 上阵位置 */
                pos: number;
            }[];
        };
    };
    41228: {
        desc: "激活武器";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 武器物品id */
            type_id: number;
        };
    };
    41230: {
        desc: "翻牌";
        send: (
            number: 41230,
            fmt: "cl",
            args: [
                /**招募类型*/
                type: number,
                /**伙伴id*/
                id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**招募类型*/
            type: number,
            /**伙伴id*/
            id: number
        ];
        recv: null;
    };
    41231: {
        desc: "客户端登陆请求显示红点";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            battlepartner: {
                /** 伙伴唯一id */
                id: number;
                /** 伙伴id */
                partnerid: number;
                /** 突破状态 0 不可突破 1 可突破 */
                break_st: number;
                base_attr: {
                    /** 属性类型 体质敏捷 */
                    type: number;
                    /** 当前值 */
                    curval: number;
                    /** 上限值 */
                    uppval: number;
                    /** 属性品质 */
                    quality: number;
                }[];
                skill: {
                    /** 技能书id */
                    sk_book: number;
                    /** 技能id */
                    sk_id: number;
                    /** 技能等级 */
                    sk_lv: number;
                    /** 技能位置 9 护主 10 天赋 */
                    sk_pos: number;
                }[];
            }[];
        };
    };
    41240: {
        desc: "审查服用";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 最大次数 */
            max_times: number;
            /** 今天已经招募次数 */
            times: number;
        };
    };
}
