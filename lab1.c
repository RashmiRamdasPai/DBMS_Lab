#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct student{
        char SID[20];
        char name[30];
        char branch[25];
        char semester[10];
        char address[25];}stu;

stu st;

void insert_new(){
        printf("\n Enter SID :");
        scanf("%s",st.SID);
        printf("\n Enter name:");
        scanf("%s",st.name);
        printf("\n Enter branch name :");
        scanf("%s",st.branch);
        printf("\n Enter semester:");
        scanf("%s",st.semester);
        printf("\n Enter address:");getchar();
        fgets(st.address,sizeof(st.address),stdin);
        st.address[strcmp(st.address,"\n")]='\0';
        FILE *fp;
        fp=fopen("student_info.txt","a");
        if(fp==NULL){
                printf("Error cant open the file now!\n");
                return;}
        fprintf(fp,"%s\t%s\t%s\t%s\t%s\n",st.SID,st.name,st.branch,st.branch,st.address);
        fclose(fp);
        printf("\n The student data has been added to the file\n");
}

void modify_add(){
        char new_ID[20];
        int flag=0;
        printf("\n Enter the id of student whose address to be modified:");
        scanf("%s",new_ID);
        FILE *fp=fopen("student_info.txt","r");
        if(fp==NULL){
                  printf("Error cant open the file now!\n");
                return;}
       FILE *fp1=fopen("sample.txt","a");
       if(fp1==NULL){printf("Error cant open the file now!\n");
                return;}
       while(fscanf(fp,"%s%s%s%s%s",st.SID,st.name,st.branch,st.semester,st.address)!=EOF){
              if(strcmp(st.SID,new_ID)==0){
                      printf("Enter the new address of the student:");
                      scanf("%s",st.address);
                      flag=1;
              }
              fprintf(fp1,"%s\t%s\t%s\t%s\t%s\n",st.SID,st.name,st.branch,st.semester,st.address);}
       if(flag==1)
               printf("The address is successfully modified\n");
       else
               printf("\n The student with the given statement ID do not exist");
       fclose(fp);
       fclose(fp1);
       remove("student_info.txt");
       rename("sample.txt","student_info.txt");
}
      void delete_st(){
              char new_ID[20];
              int flag=0;
              printf("\n Enter the student id whose entry in the file has to be deleted\n");
              scanf("%s",new_ID);
              FILE *fp=fopen("student_info.txt","r");
              if(fp==NULL){
                      printf("Error opening file\n");
                      return;}
              FILE *fp1=fopen("sample.txt","a");
       if(fp1==NULL){printf("Error cant open the file now!\n");
                return;}
         while(fscanf(fp,"%s%s%s%s%s",st.SID,st.name,st.branch,st.semester,st.address)!=EOF){
              if(strcmp(st.SID,new_ID)!=0){
                      fprintf(fp1,"%s\t%s\t%s\t%s\t%s\n",st.SID,st.name,st.branch,st.semester,st.address);
     }else
             flag=1;
         }
         if(flag==1)
                 printf("\n The student with given ID is deleted \n");
         else
                 printf("\n The given student do not exist\n");
         fclose(fp);
         fclose(fp1);
         remove("student_info.txt");
         rename("sample.txt","student_info.txt");
      }
void list_all(){
        int flag=0;
          FILE *fp=fopen("student_info.txt","r");
              if(fp==NULL){
                      printf("Error opening file\n");                      return;}
        printf("The list of all the students:\n");
        while(fscanf(fp,"%s%s%s%s%s",st.SID,st.name,st.branch,st.semester,st.address)!=EOF){
                printf("Student ID:%s \n",st.SID);
                 printf("Student name:%s \n",st.name);
                  printf("Student branch:%s \n",st.branch);
                   printf("Student ID:%s \n",st.semester);
                  printf("Student address:%s \n",st.address);printf("..\n");
                  flag=1;}
        if(!flag) printf("\n There is no student present in the given file!!\n");
        fclose(fp);
}


   void list_cse(){
        int flag=0;
         FILE *fp=fopen("student_info.txt","r");
              if(fp==NULL){
                      printf("Error opening file\n");
                      return;}
        printf("The list of all CSE the students:\n");
        while(fscanf(fp,"%s%s%s%s%s",st.SID,st.name,st.branch,st.semester,st.address)!=EOF){
               if(strcmp(st.branch,"CSE")==0){
                printf("Student ID:%s \n",st.SID);
                 printf("Student name:%s \n",st.name);
                  printf("Student branch:%s \n",st.branch);
                   printf("Student ID:%s \n",st.semester);
                  printf("Student address:%s \n",st.address);printf("..\n");
                  flag=1;}}
        if(!flag) printf("\n There is no cse student present in the given file!!\n");
        fclose(fp);
}
void list_cse_kuv(){
        int flag=0;
         FILE *fp=fopen("student_info.txt","r");
              if(fp==NULL){
                      printf("Error opening file\n");
                      return;}
        printf("The list of all CSE students who are from Kuvempunagara:\n");
        while(fscanf(fp,"%s%s%s%s%s",st.SID,st.name,st.branch,st.semester,st.address)!=EOF){
               if(strcmp(st.branch,"CSE")==0 && strcmp(st.address,"Kuvempunagara")==0){
                printf("Student ID:%s \n",st.SID);
                 printf("Student name:%s \n",st.name);
                  printf("Student branch:%s \n",st.branch);
                   printf("Student ID:%s \n",st.semester);
                  printf("Student address:%s \n",st.address);printf("..\n");
                  flag=1;}}
        if(!flag) printf("\n There is no student present in the given file who is from CSE and Kuvempunagara!!\n");
        fclose(fp);
}

int main(){
        int choice;
        while(1){
                printf("\n......Menu...\n");
                printf("\n1.Insert a new student");
                 printf("\n2.Modify the adress based on student id");
                  printf("\n3.Delete a new student");
                 printf("\n4.List all students");
                  printf("\n5.List all students of CSE branch");
          printf("\n6.List all students of CSE branch residing in Kuvempunagara");
          printf("7.Exit\n\n");
          printf("Enter your choice:");
          scanf("%d",&choice);
          switch(choice){
                  case 1:insert_new();printf("\n");break;
                   case 2:modify_add();printf("\n");break;
                   case 3:delete_st();printf("\n");break;
                   case 4:list_all();printf("\n");break;
                   case 5:list_cse();printf("\n");break;
            case 6:list_cse_kuv();printf("\n");break;
            case 7:exit(0);
                   printf("\n");break;
            default:printf("\n Invalid choice!!\n");
                    printf("\n");
                    break;}}
        return 0;
}
