//+------------------------------------------------------------------+
//|                                   Copyright 2017, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2017, Erlon F. Souza"
#property link      "https://github.com/erlonfs"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Framework\Base.mqh>

class CrossAverage : public Base
{
   private:
   
      MqlRates _rates[];
      
      //Idicadores
      int _eMALongPeriod;
   	int _eMALongHandle;
   	double _eMALongValues[];
   	int _eMAShortPeriod;
   	int _eMAShortHandle;
   	double _eMAShortValues[];
   	ENUM_MA_METHOD _eMAMethod;
   	
      bool GetBuffers() {   	
   
   		ZeroMemory(_eMALongValues);
   		ZeroMemory(_eMAShortValues);
   		ZeroMemory(_rates);
   
   		ArraySetAsSeries(_eMALongValues, true);
   		ArraySetAsSeries(_eMAShortValues, true);
   		ArraySetAsSeries(_rates, true);
   
   		int copiedMALongBuffer = CopyBuffer(_eMALongHandle, 0, 0, 10, _eMALongValues);
   		int copiedMAShortBuffer = CopyBuffer(_eMAShortHandle, 0, 0, 10, _eMAShortValues);
   		int copiedRates = CopyRates(GetSymbol(), GetPeriod(), 0, 10, _rates);
   
   		return copiedRates > 0 && copiedMALongBuffer > 0 && copiedMAShortBuffer > 0;
   
   	}
      
   public:
   
      void SetEMALongPeriod(int ema) {
   		_eMALongPeriod = ema;
   	};
   
   	void SetEMAShortPeriod(int ema) {
   		_eMAShortPeriod = ema;
   	};
   	   		
      void SetEMAMethod(ENUM_MA_METHOD maMethod) {
   		_eMAMethod = maMethod;
   	};
      
      void Load() 
   	{
         _eMALongHandle = iMA(GetSymbol(), GetPeriod(), _eMALongPeriod, 0, _eMAMethod, PRICE_CLOSE);
   		_eMAShortHandle = iMA(GetSymbol(), GetPeriod(), _eMAShortPeriod, 0, _eMAMethod, PRICE_CLOSE);
   
   		if (_eMALongHandle < 0 || _eMAShortHandle < 0) {
   			Alert("Erro ao criar indicadores: erro ", GetLastError(), "!");
   		}
   	};
   
   	void Execute() {
   	
         if(!Base::ExecuteBase()) return;
         
         if(GetBuffers()){
          
            if(_eMAShortValues[0] >= _eMALongValues[0]){
               ShowMessage("Cruzou para cima");
            }else{
               ShowMessage("Cruzou para baixo");
            }
            
         }
   		   
   	};
   	
      void ExecuteOnTrade(){
      
         Base::ExecuteOnTradeBase();
         
         //TODO
         
      };
};

