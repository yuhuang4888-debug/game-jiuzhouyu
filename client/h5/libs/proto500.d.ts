/** 护送信息
 */
declare interface ProtoFmtInfo {
    50000: {
        desc: "打开护送信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 是否双倍：0否 1是 */
            if_doudle: number;
            /** 今天剩余护送次数 */
            less_today_husong_num: number;
            /** 今天护送次数上限 */
            today_husong_num_max: number;
            reward_send_list: {
                /** 天使id */
                angel_id_1: number;
                /** 金币数量 */
                coin_num: number;
                /** 经验数量 */
                exp_num: number;
            }[];
        };
    };
    50001: {
        desc: "重新随机天使（刷新品质）";
        send: (
            number: 50001,
            fmt: "ci",
            args: [
                /**1随机一次 2随机一次自动购买 3一键随机 4一键自动购买随机*/
                rand_type: number,
                /**目标天使id（rand_type为1,2时发0）*/
                angel_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**1随机一次 2随机一次自动购买 3一键随机 4一键自动购买随机*/
            rand_type: number,
            /**目标天使id（rand_type为1,2时发0）*/
            angel_id: number
        ];
        recv: {
            /** 错误码1 */
            code1: number;
            /** 错误码2 */
            code2: number;
            /** 1随机一次 2随机一次自动购买 3一键随机 4一键自动购买随机 */
            rand_type: number;
            /** 天使id（颜色） */
            angel_id: number;
            /**  天使名字 */
            angel_name: string;
            /** 天使令数量 */
            goods_num: number;
            /** 绑钻数量 */
            bgold_num: number;
            /** 钻石数量 */
            gold_num: number;
        };
    };
    50002: {
        desc: "开始护送";
        send: (
            number: 50002,
            fmt: "i",
            args: [
                /**天使id（颜色）*/
                angel_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**天使id（颜色）*/
            angel_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 天使id（颜色） */
            angel_id: number;
        };
    };
    50003: {
        desc: "完成护送/护送结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 天使id */
            angel_id: number;
            /** 是否双倍 */
            is_double: number;
            /** 今日剩余护送次数 */
            less_husong_num: number;
        };
    };
    50004: {
        desc: "庇护";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    50005: {
        desc: "发送求助";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    50006: {
        desc: "通知场景的人玩家开始护送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 天使id */
            angel_id: number;
        };
    };
    50007: {
        desc: "玩家点击求助超链接";
        send: (
            number: 50007,
            fmt: "l",
            args: [
                /**求助玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**求助玩家id*/
            role_id: number
        ];
        recv: {
            /** 错误码  5000011为同一场景 读取下面坐标寻路 */
            code: number;
            /** 求助玩家id */
            role_id: number;
            /** x */
            x: number;
            /** y */
            y: number;
        };
    };
    50008: {
        desc: "通知护送玩家护送失败";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1超时 2被杀死 */
            type: number;
            /** 奖励经验列表 */
            exp_list: {
                /** 物品类型 */
                goods_type: number;
                /** 物品id */
                goods_type_id: number;
                /** 物品数量 */
                goods_num: number;
            }[];
        };
    };
    50009: {
        desc: "登录请求护送信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否双倍 0否 非零发双倍时间结束时间戳 */
            if_doudle: number;
            /** 阶段 0为没有 */
            stage: number;
            /** 是否领取阶段一阶段奖励 0未领 1已领 */
            reward_stage: number;
            /** 阶段一奖励列表 */
            reward_list_first: {
                /** 物品类型 */
                goods_type: number;
                /** 物品id */
                goods_type_id: number;
                /** 物品数量 */
                goods_num: number;
            }[];
        };
    };
    50010: {
        desc: "护送完切到接任务npc坐标";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    50011: {
        desc: "通知玩家护送双倍开始/结束";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否双倍：0否 1是 */
            if_doudle: number;
        };
    };
}
