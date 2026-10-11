/** vip信息
 */
declare interface ProtoFmtInfo {
    45000: {
        desc: "查看vip信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** vip等级 */
            vip_lv: number;
            /** 当前vip经验值 */
            vip_exp: number;
            /** 下级需要的元宝总数(vip等级最高后为0) */
            need_exp: number;
            got_reward_list: {
                /** 已领取奖励的vip等级 */
                got_reward: number;
            }[];
            can_reward_list: {
                /** 可领取的各等级的周礼包 */
                can_reward: number;
            }[];
            use_card_list: {
                /** 可以领取的免费卡 */
                use_card: number;
                /** 可领取的时间 有时间的，会用时间替换掉0,1  状态： 0 :未领取 1 :可领取 2： 已领取 */
                time: number;
            }[];
        };
    };
    45001: {
        desc: "领取vip奖励";
        send: (
            number: 45001,
            fmt: "h",
            args: [
                /**vip等级*/
                vip_lv: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**vip等级*/
            vip_lv: number
        ];
        recv: {
            /** 返回码: 1:成功领取 2:已被领取  3:体验卡玩家 */
            res: number;
        };
    };
    45002: {
        desc: "领取周礼包";
        send: (
            number: 45002,
            fmt: "h",
            args: [
                /**vip等级*/
                vip_lv: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**vip等级*/
            vip_lv: number
        ];
        recv: {
            /** 返回码: 1:成功领取  2:已被领取  3:体验卡玩家 */
            res: number;
        };
    };
    45003: {
        desc: "购买特权卡";
        send: (
            number: 45003,
            fmt: "c",
            args: [
                /**特权卡类型*/
                card_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**特权卡类型*/
            card_type: number
        ];
        recv: {
            /** 操作码 */
            res: number;
        };
    };
    45004: {
        desc: "特权卡信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            info: {
                /** 特权卡类型 */
                card_type: number;
                /** 是否临时卡 0 否， 1 是 */
                is_temp_card: number;
                /** 是否激活  （0未激活|1已激活） */
                is_active: number;
                /** 是否永久（0否|1是） */
                is_forever: number;
                /** 过期时间戳 */
                time: number;
            }[];
        };
    };
    45005: {
        desc: "特权卡激活信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 特权卡类型 */
            card_type: number;
            /** 是否临时卡 0 否， 1 是 */
            is_temp_card: number;
        };
    };
    45006: {
        desc: "特权卡过期";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 过期特权卡类型 */
            card_type: number;
            /** 是否临时卡 0 否， 1 是 */
            is_temp_card: number;
        };
    };
    45007: {
        desc: "免费领取卡";
        send: (
            number: 45007,
            fmt: "c",
            args: [
                /**特权卡类型*/
                card_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**特权卡类型*/
            card_type: number
        ];
        recv: {
            /** 操作码 */
            res: number;
        };
    };
}
