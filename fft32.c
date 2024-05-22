#include <stdio.h>
#include <math.h>
#include <string.h>

main(void){
int N,i,k,x[]={1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4};
int G[32],H[32],G21[16],H21[16],G22[16],H22[16],G31[8],H31[8],G32[8],H32[8],G33[8],H33[8],G34[8],H34[8];
int G41[4],H41[4],G42[4],H42[4],G43[4],H43[4],G44[4],H44[4],G45[4],H45[4],G46[4],H46[4],G47[4],H47[4],G48[4],H48[4];
int G51[2],H51[2],G52[2],H52[2],G53[2],H53[2],G54[2],H54[2],G55[2],H55[2],G56[2],H56[2],G57[2],H57[2],G58[2],H58[2];
int G59[2],H59[2],G510[2],H510[2],G511[2],H511[2],G512[2],H512[2],G513[2],H513[2],G514[2],H514[2],G515[2],H515[2],G516[2],H516[2];
float Gr,Hr,Gi,Hi,real,imag,Hr2,Hi2,Greal1[4],Gimag1[4],Hreal1[4],Himag1[4],Greal2[4],Gimag2[4],Hreal2[4],Himag2[4];
float Greal3[4],Gimag3[4],Hreal3[4],Himag3[4],Greal4[4],Gimag4[4],Hreal4[4],Himag4[4],Greal5[4],Gimag5[4],Hreal5[4],Himag5[4];
float Greal6[4],Gimag6[4],Hreal6[4],Himag6[4],Greal7[4],Gimag7[4],Hreal7[4],Himag7[4],Greal8[4],Gimag8[4],Hreal8[4],Himag8[4];
float Grealn1[64],Gimagn1[64],Hrealn1[64],Himagn1[64],Grealn2[16],Gimagn2[16],Hrealn2[16],Himagn2[16];
float Grealn3[8],Grealn4[8],Gimagn3[8],Gimagn4[8],Hrealn3[8],Himagn3[8],Hrealn4[8],Himagn4[8];
float resp1,resp2,resp3,resp4;
N=64;
for (i=0;i<8;i++){
    Grealn3[i]=0;
    Gimagn3[i]=0;
    Grealn4[i]=0;
    Gimagn4[i]=0;
}
for (i=0;i<N/2;i++){
        G[i]=x[2*i];
        H[i]=x[2*i+1];
}
for (i=0;i<N/4;i++){
        G21[i]=G[2*i];
        H21[i]=G[2*i+1];
        G22[i]=H[2*i];
        H22[i]=H[2*i+1];
}
for (i=0;i<N/8;i++){
        G31[i]=G21[2*i];
        H31[i]=G21[2*i+1];
        G32[i]=H21[2*i];
        H32[i]=H21[2*i+1];

        G33[i]=G22[2*i];
        H33[i]=G22[2*i+1];
        G34[i]=H22[2*i];
        H34[i]=H22[2*i+1];
}
for (i=0;i<N/16;i++){
        G41[i]=G31[2*i];
        H41[i]=G31[2*i+1];
        G42[i]=H31[2*i];
        H42[i]=H31[2*i+1];

        G43[i]=G32[2*i];
        H43[i]=G32[2*i+1];
        G44[i]=H32[2*i];
        H44[i]=H32[2*i+1];

        G45[i]=G33[2*i];
        H45[i]=G33[2*i+1];
        G46[i]=H33[2*i];
        H46[i]=H33[2*i+1];

        G47[i]=G34[2*i];
        H47[i]=G34[2*i+1];
        G48[i]=H34[2*i];
        H48[i]=H34[2*i+1];
}
for (i=0;i<N/32;i++){
        G51[i]=G41[2*i];
        H51[i]=G41[2*i+1];
        G52[i]=H41[2*i];
        H52[i]=H41[2*i+1];

        G53[i]=G42[2*i];
        H53[i]=G42[2*i+1];
        G54[i]=H42[2*i];
        H54[i]=H42[2*i+1];

        G55[i]=G43[2*i];
        H55[i]=G43[2*i+1];
        G56[i]=H43[2*i];
        H56[i]=H43[2*i+1];

        G57[i]=G44[2*i];
        H57[i]=G44[2*i+1];
        G58[i]=H44[2*i];
        H58[i]=H44[2*i+1];

        G59[i]=G45[2*i];
        H59[i]=G45[2*i+1];
        G510[i]=H45[2*i];
        H510[i]=H45[2*i+1];

        G511[i]=G46[2*i];
        H511[i]=G46[2*i+1];
        G512[i]=H46[2*i];
        H512[i]=H46[2*i+1];

        G513[i]=G47[2*i];
        H513[i]=G47[2*i+1];
        G514[i]=H47[2*i];
        H514[i]=H47[2*i+1];

        G515[i]=G48[2*i];
        H515[i]=G48[2*i+1];
        G516[i]=H48[2*i];
        H516[i]=H48[2*i+1];
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G51[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G51[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H51[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H51[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Greal1[k]=Gr+Hr2;
        Gimag1[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G52[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G52[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H52[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H52[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Hreal1[k]=Gr+Hr2;
        Himag1[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G53[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G53[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H53[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H53[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Greal2[k]=Gr+Hr2;
        Gimag2[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G54[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G54[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H54[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H54[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Hreal2[k]=Gr+Hr2;
        Himag2[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G55[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G55[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H55[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H55[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Greal3[k]=Gr+Hr2;
        Gimag3[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G56[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G56[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H56[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H56[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Hreal3[k]=Gr+Hr2;
        Himag3[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G57[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G57[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H57[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H57[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Greal4[k]=Gr+Hr2;
        Gimag4[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G58[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G58[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H58[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H58[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Hreal4[k]=Gr+Hr2;
        Himag4[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G59[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G59[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H59[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H59[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Greal5[k]=Gr+Hr2;
        Gimag5[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G510[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G510[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H510[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H510[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Hreal5[k]=Gr+Hr2;
        Himag5[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G511[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G511[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H511[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H511[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Greal6[k]=Gr+Hr2;
        Gimag6[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G512[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G512[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H512[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H512[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Hreal6[k]=Gr+Hr2;
        Himag6[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G513[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G513[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H513[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H513[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Greal7[k]=Gr+Hr2;
        Gimag7[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G514[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G514[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H514[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H514[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Hreal7[k]=Gr+Hr2;
        Himag7[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G515[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G515[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H515[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H515[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Greal8[k]=Gr+Hr2;
        Gimag8[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        Gr=0;
        Gi=0;
        Hr=0;
        Hi=0;
        for (i=0;i<2;i++){
            Gr=Gr+G516[i]*cos(i*k*2*3.1416/2);
            Gi=Gi-G516[i]*sin(i*k*2*3.1416/2);
            Hr=Hr+H516[i]*cos(i*k*2*3.1416/2);
            Hi=Hi-H516[i]*sin(i*k*2*3.1416/2);
        }
        Hr2=Hr*cos(2*3.1416*k/4)-Hi*sin(2*3.1416*k/4);
        Hi2=-Hr*sin(2*3.1416*k/4)+Hi*cos(2*3.1416*k/4);
        Hreal8[k]=Gr+Hr2;
        Himag8[k]=Gi+Hi2;
}
for (k=0;k<4;k++){
        resp1=Hreal1[k];
        resp2=Himag1[k];
        Hreal1[k]=resp1*cos(k*2*3.1416/8)-resp2*sin(k*2*3.1416/8);
        Himag1[k]=-resp1*sin(k*2*3.1416/8)+resp2*cos(k*2*3.1416/8);
        Grealn1[k]=Greal1[k]+Hreal1[k];
        Gimagn1[k]=Gimag1[k]+Himag1[k];
        Hreal1[k]=resp1*cos((k+4)*2*3.1416/8)-resp2*sin((k+4)*2*3.1416/8);
        Himag1[k]=-resp1*sin((k+4)*2*3.1416/8)+resp2*cos((k+4)*2*3.1416/8);
        Grealn1[k+4]=Greal1[k]+Hreal1[k];
        Gimagn1[k+4]=Gimag1[k]+Himag1[k];
}
for (k=0;k<4;k++){
        resp1=Hreal2[k];
        resp2=Himag2[k];
        Hreal2[k]=resp1*cos(k*2*3.1416/8)-resp2*sin(k*2*3.1416/8);
        Himag2[k]=-resp1*sin(k*2*3.1416/8)+resp2*cos(k*2*3.1416/8);
        Hrealn1[k]=Greal2[k]+Hreal2[k];
        Himagn1[k]=Gimag2[k]+Himag2[k];
        Hreal2[k]=resp1*cos((k+4)*2*3.1416/8)-resp2*sin((k+4)*2*3.1416/8);
        Himag2[k]=-resp1*sin((k+4)*2*3.1416/8)+resp2*cos((k+4)*2*3.1416/8);
        Hrealn1[k+4]=Greal2[k]+Hreal2[k];
        Himagn1[k+4]=Gimag2[k]+Himag2[k];
}
for (k=0;k<4;k++){
        resp1=Hreal3[k];
        resp2=Himag3[k];
        Hreal3[k]=resp1*cos(k*2*3.1416/8)-resp2*sin(k*2*3.1416/8);
        Himag3[k]=-resp1*sin(k*2*3.1416/8)+resp2*cos(k*2*3.1416/8);
        Grealn2[k]=Greal3[k]+Hreal3[k];
        Gimagn2[k]=Gimag3[k]+Himag3[k];
        Hreal3[k]=resp1*cos((k+4)*2*3.1416/8)-resp2*sin((k+4)*2*3.1416/8);
        Himag3[k]=-resp1*sin((k+4)*2*3.1416/8)+resp2*cos((k+4)*2*3.1416/8);
        Grealn2[k+4]=Greal3[k]+Hreal3[k];
        Gimagn2[k+4]=Gimag3[k]+Himag3[k];
}
for (k=0;k<4;k++){
        resp1=Hreal4[k];
        resp2=Himag4[k];
        Hreal4[k]=resp1*cos(k*2*3.1416/8)-resp2*sin(k*2*3.1416/8);
        Himag4[k]=-resp1*sin(k*2*3.1416/8)+resp2*cos(k*2*3.1416/8);
        Hrealn2[k]=Greal4[k]+Hreal4[k];
        Himagn2[k]=Gimag4[k]+Himag4[k];
        Hreal4[k]=resp1*cos((k+4)*2*3.1416/8)-resp2*sin((k+4)*2*3.1416/8);
        Himag4[k]=-resp1*sin((k+4)*2*3.1416/8)+resp2*cos((k+4)*2*3.1416/8);
        Hrealn2[k+4]=Greal4[k]+Hreal4[k];
        Himagn2[k+4]=Gimag4[k]+Himag4[k];
}
for (k=0;k<4;k++){
        resp1=Hreal5[k];
        resp2=Himag5[k];
        Hreal5[k]=resp1*cos(k*2*3.1416/8)-resp2*sin(k*2*3.1416/8);
        Himag5[k]=-resp1*sin(k*2*3.1416/8)+resp2*cos(k*2*3.1416/8);
        Grealn3[k]=Greal5[k]+Hreal5[k];
        Gimagn3[k]=Gimag5[k]+Himag5[k];
        Hreal5[k]=resp1*cos((k+4)*2*3.1416/8)-resp2*sin((k+4)*2*3.1416/8);
        Himag5[k]=-resp1*sin((k+4)*2*3.1416/8)+resp2*cos((k+4)*2*3.1416/8);
        Grealn3[k+4]=Greal5[k]+Hreal5[k];
        Gimagn3[k+4]=Gimag5[k]+Himag5[k];
}
for (k=0;k<4;k++){
        resp1=Hreal6[k];
        resp2=Himag6[k];
        Hreal6[k]=resp1*cos(k*2*3.1416/8)-resp2*sin(k*2*3.1416/8);
        Himag6[k]=-resp1*sin(k*2*3.1416/8)+resp2*cos(k*2*3.1416/8);
        Hrealn3[k]=Greal6[k]+Hreal6[k];
        Himagn3[k]=Gimag6[k]+Himag6[k];
        Hreal6[k]=resp1*cos((k+4)*2*3.1416/8)-resp2*sin((k+4)*2*3.1416/8);
        Himag6[k]=-resp1*sin((k+4)*2*3.1416/8)+resp2*cos((k+4)*2*3.1416/8);
        Hrealn3[k+4]=Greal6[k]+Hreal6[k];
        Himagn3[k+4]=Gimag6[k]+Himag6[k];
}
for (k=0;k<4;k++){
        resp1=Hreal7[k];
        resp2=Himag7[k];
        Hreal7[k]=resp1*cos(k*2*3.1416/8)-resp2*sin(k*2*3.1416/8);
        Himag7[k]=-resp1*sin(k*2*3.1416/8)+resp2*cos(k*2*3.1416/8);
        Grealn4[k]=Greal7[k]+Hreal7[k];
        Gimagn4[k]=Gimag7[k]+Himag7[k];
        Hreal7[k]=resp1*cos((k+4)*2*3.1416/8)-resp2*sin((k+4)*2*3.1416/8);
        Himag7[k]=-resp1*sin((k+4)*2*3.1416/8)+resp2*cos((k+4)*2*3.1416/8);
        Grealn4[k+4]=Greal7[k]+Hreal7[k];
        Gimagn4[k+4]=Gimag7[k]+Himag7[k];
}
for (k=0;k<4;k++){
        resp1=Hreal8[k];
        resp2=Himag8[k];
        Hreal8[k]=resp1*cos(k*2*3.1416/8)-resp2*sin(k*2*3.1416/8);
        Himag8[k]=-resp1*sin(k*2*3.1416/8)+resp2*cos(k*2*3.1416/8);
        Hrealn4[k]=Greal8[k]+Hreal8[k];
        Himagn4[k]=Gimag8[k]+Himag8[k];
        Hreal8[k]=resp1*cos((k+4)*2*3.1416/8)-resp2*sin((k+4)*2*3.1416/8);
        Himag8[k]=-resp1*sin((k+4)*2*3.1416/8)+resp2*cos((k+4)*2*3.1416/8);
        Hrealn4[k+4]=Greal8[k]+Hreal8[k];
        Himagn4[k+4]=Gimag8[k]+Himag8[k];
}
for (k=0;k<8;k++){
        resp1=Hrealn1[k];
        resp2=Himagn1[k];
        resp3=Grealn1[k];
        resp4=Gimagn1[k];
        Hrealn1[k]=resp1*cos(k*2*3.1416/16)-resp2*sin(k*2*3.1416/16);
        Himagn1[k]=-resp1*sin(k*2*3.1416/16)+resp2*cos(k*2*3.1416/16);
        Grealn1[k]=resp3+Hrealn1[k];
        Gimagn1[k]=resp4+Himagn1[k];
        Hrealn1[k]=resp1*cos((k+8)*2*3.1416/16)-resp2*sin((k+8)*2*3.1416/16);
        Himagn1[k]=-resp1*sin((k+8)*2*3.1416/16)+resp2*cos((k+8)*2*3.1416/16);
        Grealn1[k+8]=resp3+Hrealn1[k];
        Gimagn1[k+8]=resp4+Himagn1[k];
}
for (k=0;k<8;k++){
        resp1=Hrealn2[k];
        resp2=Himagn2[k];
        resp3=Grealn2[k];
        resp4=Gimagn2[k];
        Hrealn2[k]=resp1*cos(k*2*3.1416/16)-resp2*sin(k*2*3.1416/16);
        Himagn2[k]=-resp1*sin(k*2*3.1416/16)+resp2*cos(k*2*3.1416/16);
        Hrealn1[k]=resp3+Hrealn2[k];
        Himagn1[k]=resp4+Himagn2[k];
        Hrealn2[k]=resp1*cos((k+8)*2*3.1416/16)-resp2*sin((k+8)*2*3.1416/16);
        Himagn2[k]=-resp1*sin((k+8)*2*3.1416/16)+resp2*cos((k+8)*2*3.1416/16);
        Hrealn1[k+8]=resp3+Hrealn2[k];
        Himagn1[k+8]=resp4+Himagn2[k];
}
for (k=0;k<8;k++){
        resp1=Hrealn3[k];
        resp2=Himagn3[k];
        resp3=Grealn3[k];
        resp4=Gimagn3[k];
        Hrealn3[k]=resp1*cos(k*2*3.1416/16)-resp2*sin(k*2*3.1416/16);
        Himagn3[k]=-resp1*sin(k*2*3.1416/16)+resp2*cos(k*2*3.1416/16);
        Grealn2[k]=resp3+Hrealn3[k];
        Gimagn2[k]=resp4+Himagn3[k];
        Hrealn3[k]=resp1*cos((k+8)*2*3.1416/16)-resp2*sin((k+8)*2*3.1416/16);
        Himagn3[k]=-resp1*sin((k+8)*2*3.1416/16)+resp2*cos((k+8)*2*3.1416/16);
        Grealn2[k+8]=resp3+Hrealn3[k];
        Gimagn2[k+8]=resp4+Himagn3[k];
}
for (k=0;k<8;k++){
        resp1=Hrealn4[k];
        resp2=Himagn4[k];
        resp3=Grealn4[k];
        resp4=Gimagn4[k];
        Hrealn4[k]=resp1*cos(k*2*3.1416/16)-resp2*sin(k*2*3.1416/16);
        Himagn4[k]=-resp1*sin(k*2*3.1416/16)+resp2*cos(k*2*3.1416/16);
        Hrealn2[k]=resp3+Hrealn4[k];
        Himagn2[k]=resp4+Himagn4[k];
        Hrealn4[k]=resp1*cos((k+8)*2*3.1416/16)-resp2*sin((k+8)*2*3.1416/16);
        Himagn4[k]=-resp1*sin((k+8)*2*3.1416/16)+resp2*cos((k+8)*2*3.1416/16);
        Hrealn2[k+8]=resp3+Hrealn4[k];
        Himagn2[k+8]=resp4+Himagn4[k];
}
for (k=0;k<16;k++){
        resp1=Hrealn1[k];
        resp2=Himagn1[k];
        resp3=Grealn1[k];
        resp4=Gimagn1[k];
        Hrealn1[k]=resp1*cos(k*2*3.1416/32)-resp2*sin(k*2*3.1416/32);
        Himagn1[k]=-resp1*sin(k*2*3.1416/32)+resp2*cos(k*2*3.1416/32);
        Grealn1[k]=resp3+Hrealn1[k];
        Gimagn1[k]=resp4+Himagn1[k];
        Hrealn1[k]=resp1*cos((k+16)*2*3.1416/32)-resp2*sin((k+16)*2*3.1416/32);
        Himagn1[k]=-resp1*sin((k+16)*2*3.1416/32)+resp2*cos((k+16)*2*3.1416/32);
        Grealn1[k+16]=resp3+Hrealn1[k];
        Gimagn1[k+16]=resp4+Himagn1[k];
}
for (k=0;k<16;k++){
        resp1=Hrealn2[k];
        resp2=Himagn2[k];
        resp3=Grealn2[k];
        resp4=Gimagn2[k];
        Hrealn2[k]=resp1*cos(k*2*3.1416/32)-resp2*sin(k*2*3.1416/32);
        Himagn2[k]=-resp1*sin(k*2*3.1416/32)+resp2*cos(k*2*3.1416/32);
        Hrealn1[k]=resp3+Hrealn2[k];
        Himagn1[k]=resp4+Himagn2[k];
        Hrealn2[k]=resp1*cos((k+16)*2*3.1416/32)-resp2*sin((k+16)*2*3.1416/32);
        Himagn2[k]=-resp1*sin((k+16)*2*3.1416/32)+resp2*cos((k+16)*2*3.1416/32);
        Hrealn1[k+16]=resp3+Hrealn2[k];
        Himagn1[k+16]=resp4+Himagn2[k];
}
for (k=0;k<N/2;k++){
        Hr2=Hrealn1[k]*cos(2*3.1416*k/N)-Himagn1[k]*sin(2*3.1416*k/N);
        Hi2=-Hrealn1[k]*sin(2*3.1416*k/N)+Himagn1[k]*cos(2*3.1416*k/N);
        real=Grealn1[k]+Hr2;
        imag=Gimagn1[k]+Hi2;
        printf("%0.2f %0.2fj\n",real,imag);
}
for (k=0;k<N/2;k++){
        Hr2=Hrealn1[k]*cos(2*3.1416*(k+32)/N)-Himagn1[k]*sin(2*3.1416*(k+32)/N);
        Hi2=-Hrealn1[k]*sin(2*3.1416*(k+32)/N)+Himagn1[k]*cos(2*3.1416*(k+32)/N);
        real=Grealn1[k]+Hr2;
        imag=Gimagn1[k]+Hi2;
        printf("%0.2f %0.2fj\n",real,imag);
}
}
