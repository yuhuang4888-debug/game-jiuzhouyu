/** 神庭
 */
declare interface ProtoFmtInfo {
    23300: {
        desc: "通用错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            error_code_args: string;
        };
    };
    23301: {
        desc: "神庭界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            item_list: {
                /** 神庭id */
                court_id: number;
                /** 神庭等级 */
                court_lv: number;
                /** 战力汇总 */
                power: number;
                attr: any;
                /** 是否激活 0否 1是 */
                is_active: number;
                /** 装备情况 */
                equip_list: {
                    /** 位置 */
                    pos: number;
                    /** 装备id */
                    equip_id: number;
                    /** 阶数 */
                    stage: number;
                }[];
                /** 套装状况 */
                suit_list: {
                    stage: number;
                    num: number;
                }[];
            }[];
        };
    };
    23302: {
        desc: "神庭解锁";
        send: (
            number: 23302,
            fmt: "i",
            args: [
                /**神庭id*/
                court_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**神庭id*/
            court_id: number
        ];
        recv: {
            error_code: number;
            /** 神庭id */
            court_id: number;
            /** 是否激活 0否 1是 */
            is_active: number;
        };
    };
    23303: {
        desc: "装备神庭";
        send: (
            number: 23303,
            fmt: "icl",
            args: [
                /**神庭id*/
                court_id: number,
                /**位置*/
                pos: number,
                /**装备唯一Id*/
                equip_id: number
            ]
        ) => never;
        sendFmt: "icl";
        sendArgs: [
            /**神庭id*/
            court_id: number,
            /**位置*/
            pos: number,
            /**装备唯一Id*/
            equip_id: number
        ];
        recv: {
            error_code: number;
            /** 神庭id */
            court_id: number;
            /** 位置 */
            pos: number;
            /** 装备唯一Id */
            equip_id: number;
        };
    };
    23304: {
        desc: "神庭装备升阶";
        send: (
            number: 23304,
            fmt: "ic",
            args: [
                /**神庭id*/
                court_id: number,
                /**位置*/
                pos: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**神庭id*/
            court_id: number,
            /**位置*/
            pos: number
        ];
        recv: {
            error_code: number;
            /** 神庭id */
            court_id: number;
            /** 位置 */
            pos: number;
            /** 阶数 */
            stage: number;
        };
    };
    23305: {
        desc: "神庭强化";
        send: (
            number: 23305,
            fmt: "i",
            args: [
                /**神庭id*/
                court_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**神庭id*/
            court_id: number
        ];
        recv: {
            error_code: number;
            /** 神庭id */
            court_id: number;
            /** 神庭等级 */
            court_lv: number;
        };
    };
    23306: {
        desc: "神之所界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 奖池等级 */
            reward_lv: number;
            /** 升橙总次数（用户奖池限制） */
            sum_num: number;
            /** 当前水晶品质 */
            crystal_color: number;
            /** 当天升橙次数 */
            daily_num: number;
            /** 神之所等级 */
            house_lv: number;
            /** 神之所经验值 */
            house_exp: number;
            /** 升橙奖励领取状态 */
            grand_status: {
                /** 所需生成次数 */
                times: number;
                /** 领取状态 0未领取，1可领取，2已领取 */
                status: number;
            }[];
        };
    };
    23307: {
        desc: "提升水晶品质";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            /** 奖池等级 */
            reward_lv: number;
            /** 升橙总次数（用户奖池限制） */
            sum_num: number;
            /** 当前水晶品质 */
            crystal_color: number;
            /** 当天升橙次数 */
            daily_num: number;
            /** 升橙奖励领取状态 */
            grand_status: {
                /** 所需生成次数 */
                times: number;
                /** 领取状态 0未领取，1可领取，2已领取 */
                status: number;
            }[];
        };
    };
    23308: {
        desc: "开水晶（抽奖）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            /** 下次水晶品质 */
            crystal_color: number;
            /** 神之所等级 */
            house_lv: number;
            /** 神之所经验值 */
            house_exp: number;
            /** 奖励 */
            reward_list: {
                goods_type: number;
                goods_id: number;
                goods_num: number;
            }[];
        };
    };
    23309: {
        desc: "领取累计奖励（还是抽奖励）";
        send: (
            number: 23309,
            fmt: "h",
            args: [
                /**次数奖励（固定值，读kv配置获得）*/
                times: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**次数奖励（固定值，读kv配置获得）*/
            times: number
        ];
        recv: {
            error_code: number;
            /** 奖励 */
            reward_list: {
                goods_type: number;
                goods_id: number;
                goods_num: number;
            }[];
        };
    };
    23310: {
        desc: "单个神庭信息（解锁，强化，装备，升阶时返回）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 神庭id */
            court_id: number;
            /** 神庭等级 */
            court_lv: number;
            /** 战力汇总 */
            power: number;
            attr: any;
            /** 是否激活 0否 1是 */
            is_active: number;
            /** 装备情况 */
            equip_list: {
                /** 位置 */
                pos: number;
                /** 装备id */
                equip_id: number;
                /** 阶数 */
                stage: number;
            }[];
            /** 套装状况 */
            suit_list: {
                stage: number;
                num: number;
            }[];
        };
    };
}
