/** 虚空秘境
 */
declare interface ProtoFmtInfo {
    60000: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    60001: {
        desc: "活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0: 未开启 1: 已开启 */
            status: number;
            /** 结束时间戳 */
            etime: number;
            /** 是否通关 0: 未通关 1: 已通关 */
            is_pass: number;
        };
    };
    60002: {
        desc: "进入场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    60003: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    60004: {
        desc: "楼层信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动结束时间 */
            etime: number;
            /** 第几层 */
            floor: number;
            /** 当前积分 */
            score: number;
            /** 需要积分 */
            need_score: number;
            reward: {
                /** 类型 参考后台基础类型 */
                object_type: number;
                /** 物品类型id */
                type_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    60005: {
        desc: "积分更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前积分 */
            score: number;
        };
    };
    60006: {
        desc: "玩家通关";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 把玩家传送出场景的时间 */
            etime: number;
        };
    };
    60007: {
        desc: "到达新楼层";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
}
