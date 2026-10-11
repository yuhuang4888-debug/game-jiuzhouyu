/** 个人排行本
 */
declare interface ProtoFmtInfo {
    50701: {
        desc: "玩家的初始信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 今日初始层数 */
            start_level: number;
            /** 奖励状态 0未领取 1已领取 */
            rw_state: number;
            /** 当前已挑战层数列表 */
            level_list: {
                level: number;
                /** 通关时间 */
                go_time: number;
            }[];
        };
    };
    50702: {
        desc: "主界面信息(当前自己所属区间的擂主信息)";
        send: (number: 50702, fmt: "c", args: [area_id: number]) => never;
        sendFmt: "c";
        sendArgs: [area_id: number];
        recv: {
            area_id: number;
            challengers: {
                level: number;
                role_id: number;
                role_name: string;
                server_id: number;
                server_num: number;
                lv: number;
                career: number;
                sex: number;
                turn: number;
                picture: string;
                picture_ver: number;
                go_time: number;
            }[];
        };
    };
    50703: {
        desc: "左边小面板信息(查看某个区间的擂主简介)";
        send: (number: 50703, fmt: "c", args: [area_id: number]) => never;
        sendFmt: "c";
        sendArgs: [area_id: number];
        recv: {
            area_id: number;
            challengers: {
                level: number;
                role_id: number;
                role_name: string;
                server_num: number;
                go_time: number;
            }[];
        };
    };
    50704: {
        desc: "领取每日首通奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1为成功 */
            error_code: number;
            /** 状态 1：已通关(奖励未领取) 2：奖励已领取 */
            rw_state: number;
        };
    };
    50705: {
        desc: "结算界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1为成功 0 失败 */
            result_type: number;
            /** 层数 */
            level: number;
            /** 通关时间 */
            go_time: number;
            /** 是否成为擂主 1 是 */
            become_challengers: number;
            reward_list: any;
        };
    };
}
