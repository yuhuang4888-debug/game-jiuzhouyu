/** 宝宝信息
 */
declare interface ProtoFmtInfo {
    18200: {
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
    18201: {
        desc: "宝宝信息(激活时间,宝宝id,宝宝名)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 激活时间 0没激活 */
            active_time: number;
            /** 宝宝当前使用的id */
            baby_id: number;
            /**  宝宝名(没改名之前为空) */
            baby_name: string;
            /** 是否改过名 */
            is_change_name: number;
        };
    };
    18202: {
        desc: "查看别人的宝宝信息";
        send: (
            number: 18202,
            fmt: "l",
            args: [
                /**玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**玩家id*/
            role_id: number
        ];
        recv: {
            /** 列表只有一个 */
            info_list: {
                role_id: number;
                role_name: string;
                /** 激活时间 */
                active_time: number;
                /** 当前使用的宝宝id */
                baby_id: number;
                /**  宝宝名 */
                baby_name: string;
                /** 养育等级 */
                raise_lv: number;
                /** 阶数 */
                stage: number;
                /** 阶数星数 */
                stage_lv: number;
                /** 宝宝战力 */
                baby_power: number;
                /** 装备列表 */
                equip_list: {
                    /** 位置 */
                    pos_id: number;
                    /** 特长id */
                    goods_type_id: number;
                    /** 阶数 */
                    estage: number;
                    /** 等级 */
                    estage_lv: number;
                    /** 技能 */
                    skill_id: number;
                }[];
                active_list: {
                    /** 激活了的宝宝id */
                    baby_id_a: number;
                    /** 宝宝星数 */
                    baby_star: number;
                }[];
            }[];
        };
    };
    18203: {
        desc: "宝宝养育信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            raise_lv: number;
            /** 养育经验 */
            raise_exp: number;
            /** 任务列表 */
            task_list: {
                /** 任务id */
                task_id: number;
                /** 完成数 */
                finish_num: number;
                /** 完成状态 0 未完成 1 已完成 2 已领取 */
                finish_state: number;
            }[];
            /** 战力值 */
            power: number;
        };
    };
    18204: {
        desc: "宝宝培养信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阶数 */
            stage: number;
            /** 阶数星数 */
            stage_lv: number;
            /** 经验值 */
            stage_exp: number;
            /** 战力值 */
            power: number;
        };
    };
    18205: {
        desc: "宝宝装备界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            equip_list: {
                /** 位置 */
                pos_id: number;
                /** 对用的物品id */
                id: number;
                /** 特长id */
                goods_type_id: number;
                /** 阶数 */
                estage: number;
                /** 等级 */
                estage_lv: number;
                /** 经验值 */
                estage_exp: number;
                /** 技能id */
                skill_id: number;
            }[];
            /** 战力值 */
            power: number;
        };
    };
    18206: {
        desc: "幻化列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            active_list: {
                /** 激活了的宝宝id */
                baby_id_a: number;
                /** 宝宝星数 */
                baby_star: number;
            }[];
        };
    };
    18207: {
        desc: "家庭信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 列表包含自己和伴侣的宝宝信息 */
            info_list: {
                role_id: number;
                /** 激活时间 */
                active_time: number;
                /** 当前使用的宝宝id */
                baby_id: number;
                /**  宝宝名 */
                baby_name: string;
                /** 养育等级 */
                raise_lv: number;
                /** 阶数 */
                stage: number;
                /** 阶数星数 */
                stage_lv: number;
                /** 宝宝战力 */
                baby_power: number;
                attr_info: {
                    /** 1 给自己的加成 2 给伴侣的加成 */
                    type: number;
                    attr_list: {
                        attr_id: number;
                        values: number;
                    }[];
                }[];
            }[];
        };
    };
    18208: {
        desc: "点赞榜列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己的玩家id */
            role_id: number;
            praise_list: {
                /** 玩家id */
                role_id_a: number;
                role_name: string;
                /** 宝宝战力 */
                baby_power: number;
                /** 点赞数 */
                praise_num: number;
            }[];
        };
    };
    18209: {
        desc: "被点赞记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            praise_record: {
                /** 点赞者id */
                praiser_id: number;
                /**  点赞者名字 */
                praiser_name: string;
                /** 0未回点 1已回点 */
                is_praise_back: number;
            }[];
        };
    };
    18210: {
        desc: "激活宝宝";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    18211: {
        desc: "宝宝升级";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 阶数 */
            stage: number;
            /** 阶数星数 */
            stage_lv: number;
            /** 经验值 */
            stage_exp: number;
            power: number;
        };
    };
    18213: {
        desc: "激活形象/升星形象";
        send: (
            number: 18213,
            fmt: "i",
            args: [
                /**形象id*/
                baby_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**形象id*/
            baby_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 宝宝形象id */
            baby_id: number;
            /** 宝宝星数 */
            baby_star: number;
            /** 当前战力值 */
            power: number;
            /** 下一星的战力 */
            next_power: number;
        };
    };
    18214: {
        desc: "使用/不使用宝宝形象";
        send: (
            number: 18214,
            fmt: "ci",
            args: [
                /**1 使用形象 2 取消使用*/
                type: number,
                baby_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**1 使用形象 2 取消使用*/
            type: number,
            baby_id: number
        ];
        recv: {
            code: number;
            /** 1 使用形象 2 取消使用 */
            type: number;
            /** 宝宝形象id */
            baby_id: number;
        };
    };
    18215: {
        desc: "改名";
        send: (number: 18215, fmt: "s", args: [baby_name: string]) => never;
        sendFmt: "s";
        sendArgs: [baby_name: string];
        recv: {
            code: number;
            baby_name: string;
        };
    };
    18216: {
        desc: "展示宝宝";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    18217: {
        desc: "点赞宝宝";
        send: (
            number: 18217,
            fmt: "lc",
            args: [
                /**被点赞的玩家id*/
                role_id: number,
                /**1：在传闻打开界面点赞，2：自己被点赞记录里的回点*/
                opr: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**被点赞的玩家id*/
            role_id: number,
            /**1：在传闻打开界面点赞，2：自己被点赞记录里的回点*/
            opr: number
        ];
        recv: {
            code: number;
            /** 被点赞的玩家id */
            role_id: number;
            /** 1：在传闻打开界面点赞，2：自己被点赞记录里的回点 */
            opr: number;
            rewards: any;
        };
    };
    18218: {
        desc: "穿戴装备";
        send: (
            number: 18218,
            fmt: "cl",
            args: [
                /**位置id*/
                pos_id: number,
                /**物品id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**位置id*/
            pos_id: number,
            /**物品id*/
            goods_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 物品id */
            goods_id: number;
            goods_type_id: number;
            /** 技能id */
            skill_id: number;
            power: number;
        };
    };
    18219: {
        desc: "装备升阶";
        send: (
            number: 18219,
            fmt: "c",
            args: [
                /**位置id*/
                pos_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**位置id*/
            pos_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 物品id */
            goods_id: number;
            goods_type_id: number;
            stage: number;
            stage_lv: number;
            stage_exp: number;
            power: number;
        };
    };
    18220: {
        desc: "装备铭刻";
        send: (
            number: 18220,
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
            /** 错误码 */
            code: number;
            /** 位置id */
            pos_id: number;
            /** 物品id */
            goods_id: number;
            goods_type_id: number;
            /** 技能id */
            skill_id: number;
            power: number;
        };
    };
    18221: {
        desc: "宝宝任务更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 任务id */
            task_id: number;
            /** 完成数 */
            finish_num: number;
            /** 完成状态 0 未完成 1 已完成 2 已领取 */
            finish_state: number;
        };
    };
    18222: {
        desc: "领取宝宝任务奖励";
        send: (
            number: 18222,
            fmt: "h",
            args: [
                /**任务id*/
                task_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**任务id*/
            task_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 任务id */
            task_id: number;
            /** 完成数 */
            finish_num: number;
            /** 完成状态 0 未完成 1 已完成 2 已领取 */
            finish_state: number;
        };
    };
    18223: {
        desc: "查看具体某个形象的信息";
        send: (number: 18223, fmt: "i", args: [baby_id: number]) => never;
        sendFmt: "i";
        sendArgs: [baby_id: number];
        recv: {
            baby_id: number;
            /** 宝宝星数 */
            baby_star: number;
            /** 当前战力值 */
            power: number;
            /** 下一星的战力 */
            next_power: number;
        };
    };
    18224: {
        desc: "收到点赞提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 点赞者id */
            praiser_id: number;
        };
    };
}
