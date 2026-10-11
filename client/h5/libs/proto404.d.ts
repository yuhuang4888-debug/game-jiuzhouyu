/** 公会协助
 */
declare interface ProtoFmtInfo {
    40401: {
        desc: "发起协助";
        send: (
            number: 40401,
            fmt: "chil",
            args: [
                /**1 boss协助，2 副本协助*/
                type: number,
                /**boss协助：boss类型；副本协助：副本类型*/
                sub_type: number,
                /**boss协助：boss配置id；副本协助：副本id*/
                target_cfg_id: number,
                /**boss协助：boss的autoid；副本协助：可以发0*/
                target_id: number
            ]
        ) => never;
        sendFmt: "chil";
        sendArgs: [
            /**1 boss协助，2 副本协助*/
            type: number,
            /**boss协助：boss类型；副本协助：副本类型*/
            sub_type: number,
            /**boss协助：boss配置id；副本协助：副本id*/
            target_cfg_id: number,
            /**boss协助：boss的autoid；副本协助：可以发0*/
            target_id: number
        ];
        recv: {
            error_code: number;
            /** 协助id (唯一) */
            assist_id: number;
            type: number;
            sub_type: number;
            target_cfg_id: number;
            target_id: number;
        };
    };
    40402: {
        desc: "协助他人";
        send: (
            number: 40402,
            fmt: "lc",
            args: [
                /**协助id*/
                assist_id: number,
                /**1 boss协助，2 副本协助 3璀璨之海*/
                type: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**协助id*/
            assist_id: number,
            /**1 boss协助，2 副本协助 3璀璨之海*/
            type: number
        ];
        recv: {
            error_code: number;
            /** 协助id */
            assist_id: number;
            /** 1 boss协助，2 副本协助 3璀璨之海 */
            type: number;
        };
    };
    40403: {
        desc: "取消协助";
        send: (
            number: 40403,
            fmt: "l",
            args: [
                /**协助id*/
                assist_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**协助id*/
            assist_id: number
        ];
        recv: {
            error_code: number;
            /** 1 自己主动取消 2 被动取消 */
            cancel_type: number;
            /** 协助id */
            assist_id: number;
            /** 该协助的请求者 */
            ask_id: number;
        };
    };
    40404: {
        desc: "今日协助成功次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            assist_count: number;
        };
    };
    40405: {
        desc: "求助列表信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            assist_list: {
                /** 协助id */
                assist_id: number;
                /** 1 boss协助，2 副本协助 3 璀璨之星 */
                type: number;
                /** boss协助：boss类型；副本协助：副本类型；璀璨之星 1 */
                sub_type: number;
                /** boss协助：boss配置id；副本协助：副本id；璀璨之星 0 */
                target_cfg_id: number;
                /** boss协助：boss的autoid；副本协助：可以发0；璀璨之星 船只唯一id */
                target_id: number;
                role_id: number;
                name: string;
                level: number;
                career: number;
                sex: number;
                pic: string;
                pic_ver: number;
                /** 自己是否有协助这个 */
                is_assist: number;
                extra: {
                    /** (被)掠夺者服id */
                    ser_id: number;
                    /** (被)掠夺者服数量 */
                    ser_num: number;
                    /** (被)掠夺者id */
                    rober_id: number;
                    /**  (被)掠夺者名 */
                    rober_name: string;
                    /** (被)掠夺者战力 */
                    rober_power: number;
                    rober_reward: any;
                    back_reward: any;
                }[];
            }[];
        };
    };
    40406: {
        desc: "有新的求助(公会广播)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协助id */
            assist_id: number;
            /** 1 boss协助，2 副本协助 3 璀璨之星 */
            type: number;
            /** boss协助：boss类型；副本协助：副本类型；璀璨之星 1 */
            sub_type: number;
            /** boss协助：boss配置id；副本协助：副本id；璀璨之星 0 */
            target_cfg_id: number;
            /** boss协助：boss的autoid；副本协助：可以发0；璀璨之星 船只唯一id */
            target_id: number;
            role_id: number;
            name: string;
            level: number;
            career: number;
            sex: number;
            pic: string;
            pic_ver: number;
            /** 自己是否有协助这个 */
            is_assist: number;
            /** 目前协助类型3才用到 */
            extra: {
                /** (被)掠夺者服id */
                ser_id: number;
                /** (被)掠夺者服数量 */
                ser_num: number;
                /** (被)掠夺者id */
                rober_id: number;
                /**  (被)掠夺者名 */
                rober_name: string;
                /** (被)掠夺者战力 */
                rober_power: number;
                rober_reward: any;
                back_reward: any;
            }[];
        };
    };
    40407: {
        desc: "协助删除(公会广播)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协助id */
            assist_id: number;
        };
    };
    40408: {
        desc: "获取当前正在协助的对象信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协助id */
            assist_id: number;
            /** 1 boss协助，2 副本协助 3 璀璨之星 */
            type: number;
            /** boss协助：boss类型；副本协助：副本类型；璀璨之星 1 */
            sub_type: number;
            /** boss协助：boss配置id；副本协助：副本id；璀璨之星 0 */
            target_cfg_id: number;
            /** boss协助：boss的autoid；副本协助：可以发0；璀璨之星 船只唯一id */
            target_id: number;
            role_id: number;
            name: string;
            level: number;
            career: number;
            sex: number;
            pic: string;
            pic_ver: number;
        };
    };
    40409: {
        desc: "协助成功通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协助id */
            assist_id: number;
        };
    };
    40410: {
        desc: "协助通知(通知求助者)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协助id */
            assist_id: number;
            role_id: number;
            name: string;
        };
    };
}
