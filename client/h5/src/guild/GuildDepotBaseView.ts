import { BaseWindowComponent } from '../common/BaseWindowComponent';
import './GuildDepotView';

export class GuildDepotBaseView extends BaseWindowComponent {
    destroy_imm;
    is_lastView_close;
    money_list;
    preload_server_config;
    tabStrList;
    titleStr;
    viewClassList;
    _Local_Open
    public constructor() {
        super();

        this.dependent_res = ['guild'];
        this.destroy_imm = true;
        this.viewClassList = ['GuildDepotView'];
        this.titleStr = 'guild.guild_001';
        this.money_list = [2, 1, 0];
        //this.is_lastView_close = false;
        this.tabStrList = [{ label: '结社仓库' }];
        this.preload_server_config = {
            config_goods: false,
            config_equip_attr: false
        };
        this.bg_list = ['daily_bg.jpg'];
        this._Local_Open = ( parms?) => {
            if (parms&&parms[0]) {
                this.SetBackId(parms[0])
            }
            super.Open()
        }
    }

    public Open(...new_args){ 
        let parms = new_args
        this._Local_Open(parms)
    }
    public DeleteMe() {
        
        super.DeleteMe();
    }
}

window['GuildDepotBaseView'] = GuildDepotBaseView;
