
void main(List<String> args) {
  var arr =  [-1,-2];
  List<int> arr2= [];
  int sum=0,k=3;
  int negSum=0;
        arr.forEach((element) { 
          sum+=element;
          if(element>0){
            negSum+=element;
          }
        });
           if(sum<=0){
            print("negSum = $negSum");
          }
          else{
            print('sum = ${sum*k}');
          }
}
    