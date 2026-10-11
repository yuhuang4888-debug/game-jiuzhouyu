/** 领地夺宝
 */
declare interface ProtoFmtInfo {
    65201: {
        desc: "领地夺宝界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            belong_list: {
                /** 圣域id */
                dunid: number;
                /** 积分 */
                score: number;
                /** 公会id */
                guild_id: number;
                /**  公会名 */
                guild_name: string;
            }[];
            /** 领地积分 */
            territory_score: number;
            /** 有无领地 0 没有，1 有 */
            have_territory: number;
        };
    };
    65202: {
        desc: "进入协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1表示成功 */
            code: number;
            /** 副本id */
            dunid: number;
            /** 总波数 */
            total_wave: number;
            /** 本波下一波刷新时间戳 */
            first_wave_time: number;
            /** 当前波数 */
            wave: number;
            /** 剩余怪物数量 */
            num: number;
            /** 结束时间 */
            end_time: number;
        };
    };
    65203: {
        desc: "领地夺宝伤害";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己的排名 */
            self_rank: number;
            /** 伤害 */
            self_damage: number;
            /** 名字 */
            self_name: string;
            /** 与上一名的差距 */
            distance: number;
        };
    };
    65204: {
        desc: "领地夺宝伤害排名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank: {
                role_name: string;
                damage: number;
            }[];
            /** 当前波数 */
            wave: number;
            /** 剩余怪物数量 */
            num: number;
            /** 下一波刷新时间(最后一波传0) */
            time: number;
        };
    };
    65205: {
        desc: "领地夺宝结束奖励推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward: any;
        };
    };
    65206: {
        desc: "领地夺宝退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    65207: {
        desc: "获得拍卖品时推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 参与人数 */
            join_num: number;
            goods: {
                /** 物品类型id */
                goods_id: number;
                /** 数量 */
                num: number;
                /** 价格类型 1钻石 2绑钻 */
                gold_type: number;
                /** 价值 */
                worth: number;
            }[];
        };
    };
    65208: {
        desc: "领地夺宝开始结束时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            dunid: number;
            end_time: number;
        };
    };
    65209: {
        desc: "怪物消失";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            mon_id: number;
            x: number;
            y: number;
        };
    };
}
